#!/usr/local/bin/python3

import os
import sys
import subprocess

sourcefile = sys.argv[1]
path, fullfilename = os.path.split(sourcefile)
filename = os.path.splitext(fullfilename)[0]

destination = "/Volumes/HDD/Downloads/"+filename+".x3g"

gpxpath = '/Volumes/HDD/Dropbox/Design/3D-Printing/GPX-to-X3G/gpx'

subprocess.call([gpxpath, "-g","-p","-m","r2x", sourcefile, destination])