#!/bin/bash
# This script converts all images that are round in */* and outputs each image
# as CONVERT_IMAGENAME

# for loop iterator for image folders
for filename in */*
do
# Get round name. This is could vary. In this example it is
# Round_1 from Round_1/Image1
round=$(echo ${filename} | awk -F '/' '{print $1}')
# Get filename from iterator. Please change if performed directly in directory
picturefilename=$(echo ${filename} | awk -F '/' '{print $2}')
# Pipe 1: Convert image and change black values to black. Fuzz 25% is used to
# get average black values. Change higher if more background needs to be blacked
# out. Change to lower if too much is converted.
# Pipe 2: Crop image and right remove everything after X pixels (3600) 
# Pipe 3: Crop again and left remove pixels (900) and save image
convert ${filename} -fuzz 25% -fill Black -opaque 'rgb(0, 0, 0)
' - | convert - -crop 3600x3632+0+0 - | convert - -crop 0x0+900+0  ${round}/CONVERT_${picturefilename}
done
