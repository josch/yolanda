#!/usr/bin/env python
"""
    Info - get video information through gstreamer
    
    copyright 2008 - Johannes 'josch' Schauer <j.schauer@email.de>
    
    derived from discoverer.py from the python gstreamer examples.
    kudos to Edward Hervey

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
from gst.extend.discoverer import Discoverer

class FDSource(gst.BaseSrc):
    """
    borrowed from filesrc.py in the gstreamer examples
    kudos to David I. Lehn and Johan Dahlin
    only changed input from file location to file descriptor
    """
    __gsttemplates__ = (
        gst.PadTemplate("src",
                        gst.PAD_SRC,
                        gst.PAD_ALWAYS,
                        gst.caps_new_any()),
        )
    
    blocksize = 4096
    fd = None
    
    def __init__(self, name):
        self.__gobject_init__()
        self.curoffset = 0
        self.set_name(name)
    
    def set_property(self, name, value):
        if name == 'fd':
            self.fd = value
    
    def do_create(self, offset, size):
        if offset != self.curoffset:
            self.fd.seek(offset, 0)
        data = self.fd.read(self.blocksize)
        if data:
            self.curoffset += len(data)
            return gst.FLOW_OK, gst.Buffer(data)
        else:
            return gst.FLOW_UNEXPECTED, None
gobject.type_register(FDSource)

class Info(Discoverer):
    """
    Because we derive from the Discoverer class itself here, all attributes
    are directly accessible from outside as usual.
    Added a synchronous interface with get_info() and filedescriptor input.
    By implementing the MainLoop through subclassing we get maximum
    flexibility and clean code.
    """
    
    def __init__(self, fd, max_interleave=1.0):
        """
        fd: filedescriptor of the file to be discovered.
        max_interleave: int or float; the maximum frame interleave in seconds.
            The value must be greater than the input file frame interleave
            or the discoverer may not find out all input file's streams.
            The default value is 1 second and you shouldn't have to change it,
            changing it mean larger discovering time and bigger memory usage.
        this init is 90% copy of the original but with a filedescriptor instead
        a filename and three lines to init the main event loop
        """
        gobject.GObject.__init__(self)

        self.mimetype = None

        self.audiocaps = {}
        self.videocaps = {}

        self.videowidth = 0
        self.videoheight = 0
        self.videorate = gst.Fraction(0,1)

        self.audiofloat = False
        self.audiorate = 0
        self.audiodepth = 0
        self.audiowidth = 0
        self.audiochannels = 0

        self.audiolength = 0L
        self.videolength = 0L

        self.is_video = False
        self.is_audio = False

        self.otherstreams = []

        self.finished = False
        self.tags = {}
        self._success = False
        self._nomorepads = False

        self._timeout = 9001 # ALL HAIL THE CARGO CULT
        self._timeoutid = 0
        self._max_interleave = max_interleave
        
        # first mod of original __init__ to use a filedescriptor source
        if type(fd) is not file:
            raise TypeError, "expected file like input, got %s"%type(fd)
        
        # the initial elements of the pipeline
        self.src = FDSource('filesrc')
        self.src.set_property("fd", fd)
        self.dbin = gst.element_factory_make("decodebin")
        self.add(self.src, self.dbin)
        self.src.link(self.dbin)
        self.typefind = self.dbin.get_by_name("typefind")

        # callbacks
        self.typefind.connect("have-type", self._have_type_cb)
        self.dbin.connect("new-decoded-pad", self._new_decoded_pad_cb)
        self.dbin.connect("no-more-pads", self._no_more_pads_cb)
        self.dbin.connect("unknown-type", self._unknown_type_cb)
        
        # second mod to the discoverer __init__ to implement a main loop
        self.connect('discovered', self._discovered)
        gobject.idle_add(self._discover)
        self.mainloop = gobject.MainLoop()
        
    def get_info(self):
        """
        By running the main loop this will fire off the discover function.
        The main loop will return when something was discovered.
        The function returns wether or not the discovering was successful.
        """
        self.mainloop.run()
        #only return true if source is a valid video file
        return self.finished and self.mimetype and \
               self.is_video and self.videorate.num/self.videorate.denom
        
    def _discovered(self, discoverer, ismedia):
        """When we discover something - quit main loop"""
        gobject.idle_add(self.mainloop.quit)
    
    def _discover(self):
        """
        when we are not finished (eg. because the file is invalid) then try
        to discover video information (that will call the discovered function)
        otherwise stop the main loop
        """
        if self.finished:
            gobject.idle_add(self.mainloop.quit)
        else:
            self.discover()
        return False
        
def main(args):
    """here we add a nice cli interface and some example how to use the lib"""
    if len(args) != 2:
        print 'usage: %s file' % args[0]
        return 2
    
    input = open(args[1], "rb")
    info = Info(input)
    if info.get_info():
        info.print_info()

if __name__ == '__main__':
    sys.exit(main(sys.argv))
