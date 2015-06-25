#!/usr/local/bin/python3

# 1) Make this file executable with `chmod +x /path/to/this/file`
# 2) Replace the shebang path with the result of `which python3`
# 3) In slic3r, go to Print Settings > Output options > Post-processing scripts
#    and put the full path to this file. The path cannot contain any spaces,
#    even if they are escaped.  

import os
import sys
import subprocess

sourcefile = sys.argv[1]
path, fullfilename = os.path.split(sourcefile)
filename = os.path.splitext(fullfilename)[0]

destination = "/Volumes/HDD/Downloads/"+filename+".x3g"

gpxpath = '/Volumes/HDD/Dropbox/Design/3D-Printing/GPX-to-X3G/gpx'

subprocess.call([gpxpath, "-g","-p","-m","r2x", sourcefile, destination])