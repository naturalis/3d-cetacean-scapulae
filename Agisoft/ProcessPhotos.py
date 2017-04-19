# Sebastiaan de Vriend
#
# This script processes raw chunks to a 3D model.
# Option: --rm0.5: Copy chunk and apply 0.5 correction.
# Option: --sleep X: Sleep for x seconds. Insert Interger into X.
#
# Before running the script, make sure that the first chunk is named. Samplename_raw
# EG: Sample1_raw
# This is automaticcally aplied by AddBulkData.py
#
# The script proceeeds the standard workflow of Agisoft.
# Align photo's -> Build dense cloud -> build Mesh -> build texture -> export model.
#
# See each function for settings.
#
# The 0.5 correction is explained in the function's documentation.
#
# Average runtime depends on the number of images and 0.5, expect a runtime of 3 hours per model.

import sys
import time

def alignPhotos(chunk):
    """
    The function alligns all tif files in a chunk.
    Accuracy: High: Highest takes too much time and high yields cooperative results.
    Preselection: Disabled. Not required. Can introduce errors when enabled.
    filter_mask: Features by mask. Enabled to align masked data.
    keypoint_limit: 0, infinity.
    tiepoint_limit: 10.000: Can be set to 0 if results are bad.
    :param chunk: Current chunk
    :return: Tie-point cloud
    """
    chunk.matchPhotos(accuracy=PhotoScan.HighAccuracy, preselection=PhotoScan.NoPreselection, 
                      filter_mask=True, keypoint_limit=0, tiepoint_limit=10000)
    chunk.alignCameras()

def buildDense(chunk):
    """
    The function creates a dense cloud from a point cloud.
    Quality: High: Yields a good Dense cloud for a 3D model.
    filter: MildFiltering: Applies a mild filtering. There is almost no background noise,
                            masking allows to use the mild filtering.
    A higher quality can be used for models with holes, else, it consumes a large amount
    of time with no additional yields.
    :param chunk: Agisoft chunk.
    :return: A dense cloud in Agisoft.
    """
    chunk.buildDenseCloud(quality=PhotoScan.HighQuality, filter=PhotoScan.MildFiltering)

def buildmodel(chunk):
    """
    Function builds a mesh from a dense cloud
    :param chunk: Current chunk with dense cloud.
    :return: 3D mesh.
    """
    chunk.buildModel()

def buildtexture(chunk):
    """
    Function builds texture around mesh. This gives a 3D model "the real look". Not really needed for
    3D analysis, but for 5 minutes time, it adds a good value for collection.
    :param chunk: Chunk with mesh.
    :return: A nice looking 3D model.
    """
    chunk.buildUV()
    chunk.buildTexture()


def exportdata(chunk, path):
    """
    Function exports input chunk as a 3D pdf, and a ply file with no binary encoding. (some software can't read binary)

    :param chunk: Current chunk.
    :param path: Document path. Exmaple: C:\Users\Documents\Sample1\
    :return: Exported ply and pdf file in the directory provided by path variable.
    """
    filename = str("/".join(path) + "/" + chunk.label + "_Automatic")
    chunk.exportModel(str(filename + ".pdf"), binary=False, format="pdf")
    chunk.exportModel(str(filename + ".ply"), binary=False, format="ply", texture_format="jpg")

def main(args):
    """
    The function checks if the sleep param is used first to let Agisoft hang, or sleep for
    x seconds, to run multiple models.

    The function then gets a path from agisoft, that is used in the chunk naming.
    Then, the raw chunk is assigned, and alligned.

    After the first allignment, the image score is calculated, and the --raw0.5 parmameter is checked.
    This correction is based on the quality score of the images. The Agisoft User manual states that images
    below 0.5 can yield a bad result. This 0.5 correction disables the images lower than 0.5 in a new chunk.
    This is to compare the results later on.

    Both chunks are processed in a standard Agisoft workflow:
    Align photos -> Build dense cloud -> Build mesh -> Build texture -> Export model.

    After each step in the workflow, the Agisoft project is saved.

    The script closes Agisoft when it is finished.
    :param args:
    :return: two 3D models.
    """
    if "--sleep" in args:
        sleeptime = args[3] # PLEASE CHANGE THIS!
        print("TIME TO SLEEP FOR", sleeptime, "seconds !")        
        time.sleep(float(sleeptime))

    # Get Agisoft properties: Samplename, path.
    doc = PhotoScan.app.document
    docpath = doc.path
    basepath = docpath.split("/")
    samplename = basepath.pop(-1).rstrip(".psx")
    # Check all chunks to detect raw chunk.
    for chunk in doc.chunks:
        if chunk.label == str(samplename + "_raw"):
            raw_chunk = chunk
    # align raw chunk.
    alignPhotos(raw_chunk)
    doc.save()
    # Estimage image quality.
    raw_chunk.estimateImageQuality()
    if "--rm0.5" in args:
        for camera in raw_chunk.cameras:
    	    if float(camera.photo.meta['Image/Quality']) < 0.5:
                camera.enabled = False # Disable image if quality is lower than 0.5
        print("Apply 0.5 correction.")
        # Copy raw to new chunk and rename
        Corr_Chunk = raw_chunk.copy()
        Corr_Chunk.label = str(samplename + "_0.5Cor")
        # Standard workflow for 0.5 chunk
        doc.save()
        alignPhotos(Corr_Chunk)
        doc.save()
        buildDense(Corr_Chunk)
        doc.save()
        buildmodel(Corr_Chunk)
        buildtexture(Corr_Chunk)
        doc.save()
        exportdata(Corr_Chunk, basepath)
    # Standard workflow for raw chunk.
    buildDense(raw_chunk)
    doc.save()
    buildmodel(raw_chunk)
    buildtexture(raw_chunk)
    doc.save()
    exportdata(raw_chunk, basepath)
    # Close Agisoft.
    PhotoScan.app.quit()


if __name__ == "__main__":
    main(sys.argv)