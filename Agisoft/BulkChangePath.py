"""
Sebastiaan de Vriend

You can use this script when you are changing the directory of the project files, or moving pictures.
This script will set all the paths back correctly, so you don't have to do it manually for all your data.

This script is for Agisoft PhotoScan in python 3.
The script assumes that the samples are located in a folder near the Agisoft project file.
For example:
C:\Models\Sample1\Sample1.psx <- Agisoft photosave file.
and moved the pictures to
C:\Models\Sample1\Sample1
I am working with rounds. So the script automatically sets the rounds correct.
This means that a picture can be found in:
C:\Models\Sample1\Sample1\Round_1\Round_1_DSC4495.tif
"""
import PhotoScan


doc = PhotoScan.app.document
docpath = doc.path # Document location in Windows
basepath = docpath.split("/")
samplename = basepath.pop(-1).rstrip(".psx")

# Now the script iterates through all chunks in the Agisoft project.
for chunk in doc.chunks:
    # Each camera in the current chunk is iterated.
    for camera in chunk.cameras:
        oldpath = camera.photo.path.split("/")
        filename = oldpath.pop(-1) # Get filename
        round = oldpath.pop(-1) # Get round number.
        #round = "all" # uncomment when all is used instead of rounds
        newpath = str("/".join(basepath) + "/" + samplename + "/" + round + "/" + filename)
        # EG: newpath = C:/Users/Documents/Models/Sample1/Sample1/Round_1/Round_1_IMG_001.tif
        camera.photo.path = newpath

print("Paths are changed! Basepath = " + basepath)