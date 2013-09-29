#/bin/sh

# DESCRIPTION:
# Take all .NEF files from my Nikon camera, rename then to the timestamp
# they were taken, and output a JPEG copy as well with proper rotation.

# AUTHOR:
# Arild Jensen (arildjensen@yahoo.com)

for i in *.NEF; do
	datestamp=`exifprobe -L $i | \\
    grep DateTimeOriginal | \\
    head -n 1 | \\
    awk -F \' '{print $2}' | \\
    sed 's/://g' | \\
    sed 's/ /_/g'`;
	mv $i $datestamp.nef
	ufraw-batch --out-type=jpg --rotate=camera $datestamp.nef
done;
