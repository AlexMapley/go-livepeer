#!/usr/bin/env bash

FILE="$1"

echo "package core" > $FILE
echo "// Auto generated by $0 DO NOT EDIT" >> $FILE
echo "var testSegment = []byte{" >> $FILE
ffmpeg -f lavfi -i color=white:s=48x48 -vframes 5  -c:v libx264 -f mpegts - |  \
  ffmpeg -f mpegts -i pipe:0 -c:v copy -bsf:v 'filter_units=pass_types=1-5|7-15' \
  -f mpegts -metadata title='!' -metadata service_provider='!' - | gzip -9  | \
  xxd -i | awk 'NR > 1 { print prev } { prev=$0 } END { ORS=""; print }'  >> $FILE

echo "}" >> $FILE