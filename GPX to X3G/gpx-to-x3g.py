#!/usr/local/bin/python3

import os
import sys
import subprocess

path, fullfilename = os.path.split(sys.argv[1])
filename = os.path.splitext(fullfilename)[0]

gpxpath = '/Volumes/HDD/Dropbox/Design/3D\ Printing/GPX\ to\ X3G/gpx'
args = '-g -p -m r1x ~/Downloads/'+filename+'.x3g'

subprocess.call(gpxpath + " " + args, shell=True)