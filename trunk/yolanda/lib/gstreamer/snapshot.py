#!/usr/bin/env python
"""
    Snapshot - get video thumbnail through gstreamer
    
    copyright 2008 - Johannes 'josch' Schauer <j.schauer@email.de>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

import sys, os
import gobject

#DO NOT FORGET THIS OR A RAPTOR WILL COME AND GET YOU!
gobject.threads_init()

import pygst
pygst.require("0.10")
import gst

import Image
import ImageStat
import ImageOps

import random

#adjust this if necessary
BORING_IMAGE_VARIANCE = 500
NUMBER_OF_TRIES = 10

class Snapshot:
    """
    take interesting video snapshots.
    """
    
    def _capture_interesting_frame(self, pad, buffer):
        """
        this is the buffer probe which processes every frame that is being
        played by the capture pipeline. since the first frame is not random, we
        skip this frame by setting the self.first_analyze flag.
        if the current frame is found intersting we save it. if not we decrease
        self.tries to limit the number of tries
        """
        if not self.first_analyze:
            #get current buffer's capabilities
            caps = buffer.get_caps ()
            #we are interested in it's dimension
            height, width = caps[0]['height'], caps[0]['width']
            #using PIL we grab the image in raw RGB mode from the buffer data
            im = Image.frombuffer('RGB', (width, height), buffer.data,'raw', 'RGB', 0, 1)
            #here we check the standard variance of a grayscale version of the
            #current frame against the BORING_IMAGE_VARIANCE
            if ImageStat.Stat(ImageOps.grayscale(im)).var[0] > \
                BORING_IMAGE_VARIANCE:
                #success! save our interesting image
                self.image = im
            else:
                #the image is just useless... retry...
                self.tries -= 1
        else:
            self.first_analyze = False
        return True
    
    def _build_pipeline(self):
        """
        here we init our capturing pipeline.
        """
        self.player = gst.Pipeline("player")
        source = gst.element_factory_make("filesrc", "file-source")
        source.set_property("location", self.filename)
        decodebin = gst.element_factory_make("decodebin", "decodebin")
        #connect the pad-added signal to the apropriate callback
        decodebin.connect("pad-added", self._decodebin_cb)
        queuev = gst.element_factory_make("queue", "queuev")
        ffmpeg = gst.element_factory_make("ffmpegcolorspace", "ffmpeg")
        #we use the capsfilter to convert our videostream from YUV to RGB
        filter = gst.element_factory_make("capsfilter", "filter")
        filter.set_property("caps", gst.caps_from_string("video/x-raw-rgb"))
        fakesink = gst.element_factory_make("fakesink", "fakesink")
        
        #add all elements to the capture pipeline
        self.player.add(source, decodebin, ffmpeg, filter, fakesink, queuev)
        #do some linking - only the link between decodebin and queuev is done
        #later by the _decodebin_cb callback function
        gst.element_link_many(source, decodebin)
        gst.element_link_many(queuev, ffmpeg, filter, fakesink)
        
        #we add a buffer probe to the capsfilter output pad. every frame will
        #get passed to the _capture_interesting_frame function
        self.player.get_by_name('filter').get_pad('src').\
            add_buffer_probe(self._capture_interesting_frame)
        
        #watch for messages
        bus = self.player.get_bus()
        bus.add_signal_watch()
        bus.connect("message", self._on_message)
        
        #start pipeline
        self.player.set_state(gst.STATE_PLAYING)
    
    def __init__(self, filename):
        """
        lets init some variables, check if the video file exists and add a
        signal to the mainloop that executes _build_pipeline the instant the
        mainloop is run
        """
        if not os.path.isfile(filename):
            raise IOError, "cannot read file"
        self.filename = filename
        self.time_format = gst.Format(gst.FORMAT_TIME)
        #we add a signal to immediately execute the pipeline builder after
        #the mainloop is actually run
        gobject.idle_add(self._build_pipeline)
        self.mainloop = gobject.MainLoop()
        #this is set to False after the first run. this prevents the first
        #frame processed by the buffer probe from not being random
        self.first_analyze = True
        #set the number of retries
        self.tries = NUMBER_OF_TRIES
        #if this is set the main loop is quit and the image returned
        self.image = None
        #we find this out before seeking
        self.duration = None
        
    def get_snapshot(self):
        """
        by starting the mainloop the capture pipeline will be build. this will
        at some point issue an ASYNC_DONE message. this again will seek the
        playing capture pipeline to a random position. a buffer probe will grab
        the first frame played and test wether it is an intersting fellow.
        if so, the random seeking will stop and we will quit the mainloop. this
        will result in this function returning the captured image
        """
        self.mainloop.run()
        return self.image
    
    def _seek_and_play_random(self):
        """
        this function gets repeatedly called because it is linked to the
        ASYNC_DONE event which it itself also emits when seeking is finished.
        here we only seek to a random position in the video stream
        """
        #there are some cases in which this tries to seek after the maximum
        #number of tries is reached and the player is already nullyfied
        if self.tries > 0:
            #if we didn't already set the duration - do it now
            #meaybe this can be done earlier but i didnt figure out when
            if self.duration is None:
                self.duration = self.player.query_duration(self.time_format,
                                                            None)[0]
            #seek to random position. this will again fire an ASYNC_DONE and
            #let the frame we seeked to be rendered by the buffer probe
            self.player.seek_simple(self.time_format, gst.SEEK_FLAG_FLUSH,
                random.randint(1, self.duration))
    
    def _on_message(self, bus, message):
        """
        since seeking issues the ASYNC signal we create an infinite loop here.
        on each frame being seeked to the buffer probe function
        _capture_interesting_frame gets called. this will fill self.im with a
        non-boring screenshot which will then cause this _seek_and_play_random
        loop to be finished
        """
        t = message.type
        if t == gst.MESSAGE_ASYNC_DONE:
            #only loop again if there is still no image and tries are left
            if self.image is not None or self.tries < 1:
                #success! clean everything up
                self.player.set_state(gst.STATE_NULL)
                gobject.idle_add(self.mainloop.quit)
            else:
                #issue new seeking that probably will bring us here again
                gobject.idle_add(self._seek_and_play_random)
        elif t == gst.MESSAGE_EOS:
            #somehow we seeded into the end of file - lets seek to a new pos
            gobject.idle_add(self._seek_and_play_random)
        elif t == gst.MESSAGE_ERROR:
            #oups error - this shouldn't happen'
            err, debug = message.parse_error()
            print "Error: %s" % err, debug
            self.player.set_state(gst.STATE_NULL)
            gobject.idle_add(self.mainloop.quit)
    
    def _decodebin_cb(self, decodebin, pad):
        """
        when the decode bin is ready, a new pad is added for the video stream
        we connect this pad to our video queue sink here
        """
        #only do so if pad is not already linked to something
        if not pad.is_linked():
            #only do this for the video stream - we are not interested in audio
            if "video" in pad.get_caps()[0].get_name():
                #do the linking from the source pad to the queue's sink
                pad.link(self.player.get_by_name("queuev").get_pad("sink"))
        
def main(args):
    """here we add a nice cli interface and some example how to use the lib"""
    if len(args) != 2:
        print 'usage: %s file' % args[0]
        return 2

    snapshot = Snapshot(args[1])
    im = snapshot.get_snapshot()
    if im:
        print "SUCCESS!"
        im.save("%s.jpg" %args[1], "JPEG")

if __name__ == '__main__':
    sys.exit(main(sys.argv))
