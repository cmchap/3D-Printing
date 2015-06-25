#!/usr/local/bin/python3

# Make this file executable with `chmod +x /path/to/this/file`
# Replace the shebang path with the result of `which python3`
# Set Slic3r's post-processing script to point to this file. 

import os
import sys
import subprocess

sourcefile = sys.argv[1]
path, fullfilename = os.path.split(sourcefile)
filename = os.path.splitext(fullfilename)[0]

destination = "/Volumes/HDD/Downloads/"+filename+".x3g"

gpxpath = '/Volumes/HDD/Dropbox/Design/3D-Printing/GPX-to-X3G/gpx'

subprocess.call([gpxpath, "-g","-p","-m","r2x", sourcefile, destination])