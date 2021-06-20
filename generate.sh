#!/bin/sh

wpm=25
ewpm=3
textfile=romans1.txt
outfile=romans
title="Romans 1 - "

#for i in romans1-01 romans1-02 romans1-08 romans1-13 romans1-16 romans1-18; do
#  echo $i
#  ./ebook2cw -w ${wpm} -e ${ewpm} -c "" -o "${i}_${wpm}_${ewpm}" -t "$i $wpm $ewpm" $i.txt
#done

cat $textfile | sed 's/\!/\./g '| sed 's/[^0-9a-zA-Z\ \-\.\,]//g' | sed 's/\./\. BREAK /g' > /tmp/$$.txt
cat /tmp/$$.txt
./ebook2cw -w ${wpm} -e ${ewpm} -c BREAK -t "${title} ${wpm} ${ewpm}" -o ${outfile} /tmp/$$.txt

rm -f /tmp/$$.txt
