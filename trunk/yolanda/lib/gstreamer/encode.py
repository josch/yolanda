#!/usr/bin/env python
"""
    Encode - convert video to theora through gstreamer
    
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

class Encode:
    """
    Converts media files gstreamer can play to Ogg Theora + Vorbis.
    """
    def _build_pipeline(self):
        self.player = gst.Pipeline("player")
        source = gst.element_factory_make("filesrc", "file-source")
        source.set_property("location", self.source)
        decodebin = gst.element_factory_make("decodebin", "decodebin")
        decodebin.connect("pad-added", self.decodebin_callback)
        audioconvert = gst.element_factory_make("audioconvert", "audioconvert")
        rsmpl = gst.element_factory_make('audioresample')
        vorbisenc = gst.element_factory_make("vorbisenc", "vorbisenc")
        #set audio quality (max: 1.0, default: TODO)
        vorbisenc.set_property("quality", self.audioquality)
        ffmpeg = gst.element_factory_make("ffmpegcolorspace", "ffmpeg")
        filter = gst.element_factory_make("capsfilter", "filter")
        #filter.set_property("caps", gst.caps_from_string("width=64,height=64"))
        videoscale = gst.element_factory_make("videoscale", "videoscale")
        videoscale.set_property("method", 1)
        videorate = gst.element_factory_make("videorate", "videorate")
        theoraenc = gst.element_factory_make("theoraenc", "theoraenc")
        #set video quality (max: 63, default: 16)
        theoraenc.set_property("quality", self.videoquality)
        #set quick property (default: True)
        theoraenc.set_property("quick", self.quick)
        #set sharpness property (default: TODO)
        theoraenc.set_property("sharpness", self.sharpness)
        queuea = gst.element_factory_make("queue", "queuea")
        queuev = gst.element_factory_make("queue", "queuev")
        muxer = gst.element_factory_make("oggmux", "muxer")
        filesink = gst.element_factory_make("filesink", "filesink")
        filesink.set_property("location", self.destination)
        
        self.player.add(source, decodebin, ffmpeg, muxer, filesink, videorate,
            videoscale, audioconvert, vorbisenc, theoraenc, queuea, queuev,
            rsmpl, filter)
        gst.element_link_many(source, decodebin)
        if self.video:
            gst.element_link_many(queuev, ffmpeg, filter, videoscale,
            videorate, theoraenc, muxer)
        if self.audio:
            gst.element_link_many(queuea, audioconvert, rsmpl, vorbisenc,
            muxer)
        gst.element_link_many(muxer, filesink)
        
        bus = self.player.get_bus()
        bus.add_signal_watch()
        bus.connect("message", self.on_message)
        self.player.set_state(gst.STATE_PLAYING)
    
    def __init__(self, source, destination, videoquality=16, quick=True, sharpness=2,
                 video=True, audio=True, audioquality=0.1):
        if not os.path.isfile(source):
            raise IOError, "input file does not exist"
        self.source = source
        self.destination = destination
        if not video and not audio:
            raise AttributeError, "input file does not contain video or audio"
        self.video = bool(video)
        self.audio = bool(audio)
        if not 1 <= int(videoquality) <= 63:
            raise ValueError, "videoquality out of range 1-63"
        self.videoquality=int(videoquality)
        self.quick = bool(quick)
        if not 0 <= int(sharpness) <= 2:
            raise ValueError, "sharpness ouf of range 0-2"
        self.sharpness = int(sharpness)
        if not 0 <= float(audioquality) <= 1.0:
            raise ValueError, "audioquality out of range 0.0-1.0"
        self.audioquality = float(audioquality)
        
        self.failed = False
        gobject.idle_add(self._build_pipeline)
        self.mainloop = gobject.MainLoop()
        
    def run(self):
        """
        Starts the actual encoding process.
        """
        self.mainloop.run()
        return not self.failed
    
    def on_message(self, bus, message):
        t = message.type
        if t == gst.MESSAGE_EOS:
            self.player.set_state(gst.STATE_NULL)
            gobject.idle_add(self.mainloop.quit)
        elif t == gst.MESSAGE_ERROR:
            err, debug = message.parse_error()
            print "Error: %s" % err, debug
            self.failed = True
            self.player.set_state(gst.STATE_NULL)
            gobject.idle_add(self.mainloop.quit)
    
    def decodebin_callback(self, decodebin, pad):
        if not pad.is_linked():
            if "video" in pad.get_caps()[0].get_name():
                pad.link(self.player.get_by_name("queuev").get_pad("sink"))
            elif "audio" in pad.get_caps()[0].get_name():
                pad.link(self.player.get_by_name("queuea").get_pad("sink"))
        
def main(args):
    if len(args) != 2:
        print 'usage: %s file' % args[0]
        return 2

    encode = Encode(args[1], args[1]+".ogv")
    encode.run()

if __name__ == '__main__':
    sys.exit(main(sys.argv))
