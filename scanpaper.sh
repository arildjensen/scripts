#!/bin/bash

# https://github.com/arildjensen/scripts
# Scans pages from my flatbed scanner at about 15 kB/page.

datestamp=`date -u +%s`

echo ${datestamp}

scanimage \
  --mode Lineart \
  --resolution 300 \
  --format=tiff \
  --batch="scanimage-output-%03d.tif" \
  --batch-prompt \
  --progress \
  -l 0 \
  -t 0 \
  -x 215 \
  -y 279

tiffcp -c lzw scanimage-out*.tif scan.tif
tiff2pdf -z -o scan${datestamp}.pdf scan.tif
rm *.tif
ls -lh scan${datestamp}.pdf
