## Agisoft
Scripts that were created for Agisoft Photoscan Professional can be found here. The application programming interface manual can be found online: (http://www.agisoft.com/).
Version 1.2.5 of the python reference is used with python 3 and Agisoft PhotoScan Professional 1.2.

Scripts can be executed in the Agisoft menu: <b>Tools > Run Script. </b>

### AddBulkData
This script imports all the data into the Agisoft project and loads manual set masks. This works when the following folder structure is used:  
 ``` 
SampleID  
-SampleID  
--Round_1  
---Image_1.tif  
---Image_2.tif  
--Round_2  
---Image_3.tif  
---Image_4.tif  
-SampleID.psx  <- Agisoft project file
  ```
The Agisoft project has to be saved first before using the script.

### BulkChangePath
This script is useful when an Agisoft project is used on different computers with different folder paths and when Agisoft complains that no images can be found. This error could be caused when a project is transferred to another person. Agisoft keeps track of used paths per image. For example:

```
C:\Users\Sjors\Documents\Image_1.tif
```
Is changed to:
```
C:\Users\Sebastiaan\Documents\Image_1.tif
```
### ProcessPhotos
Images can be set correctly manually or with this script. The script will use the current location of the Agisoft project to change the path of al images in the project.


This script process photos into a 3D model with settings that were advised by Edwin van Spronsen. Masked have to be set first, and there has to be a chunk available that is labeled like “Sample_raw”. This is automatically done by the AddBulkData script. The models are exported as a non-binary ply file and as a 3D pdf, which can be viewed with Adobe PDF reader.
There are two inputs available. These can be set in the arguments box when running a script.
```
--rm0.5  
This will disable photos that have a quality lower than 0.5 and will yield an extra model.
```
```
--sleep X  
This option will sleep Agisoft for x seconds. It takes an average of 3 hours to complete a run. So for each time this option is used X has to be increased by 10800. For each model an Agisoft program has to be opened. 
```
### Guide
A guide on photogrammetry and basic Agisoft settings will be available here before the end of this internship.
