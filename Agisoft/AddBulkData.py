# Sebastiaan de Vriend
#
# This script can be used to add tif files from different folders to a chunk in Agisoft,
# and to import the masks that are created in Adobe photoshop.
#
# The script assumes that the images are in a folder that is located near
# the Agisoft psx file.
# To use: Save the Agisoft document as the samplename. You can save
# the Agisoft project by pressing ctrl+s, and typing .psx on the file location as
# seen below.
# EG: C:\Users\Documents\Sample1\Sample1.psx
# Pictures have to be located in a sub folder.
# EG: C:\Users\Documents\Sample1\Sample1\Round_1\
#
# The script iterates through the files and saves the project when
# every tif file in the sub folder is added.
import PhotoScan
import os

# Get project location.
doc = PhotoScan.app.document
docpath = doc.path.split("/")
samplename = docpath.pop(-1).rstrip(".psx")

# Add chunk for raw data.
doc.addChunk()
doc.chunk.label = str(samplename + "_raw")

# Create file list. This loop wil add full paths from each .tif file.
# EG: C:\Users\Documents\Sample1\Sample1\Round_1\Image_1.tif
filelist = []
for root, subdirs, files in os.walk(str("/".join(docpath) + "/" + samplename)):
    for filename in files:
        if filename[-4:] == ".tif":
            filelist.append(os.path.join(root, filename).replace("\\", "/"))

# Add filelist to chunk. This will load the tif data into Agisoft.
doc.chunk.addPhotos(filelist)

# Iterate images in chunk. Add thunbnails to all images.
for photo in doc.chunk.cameras:
    photo.photo.thumbnail(width=192, height=192)

# Import alpha masks in Agisoft. This can take a few minutes.
doc.chunk.importMasks(method='alpha', operation='replacement')

# Save project
doc.save()

print("Data is added and ready for processing!")
