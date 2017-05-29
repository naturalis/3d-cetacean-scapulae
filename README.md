# 3D-Cetacean-scalpulae

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

## Galaxy
This folder contains the scripts and xml files that are used in Galaxy. A temporary Galaxy is set online and can be tested with a supplementary file (http://145.136.241.84:8080/). 

### Install_R-packages
This script can be used to install packages that are required by the Galaxy pipeline. It is advised to run this script in the shell environment. The script installs:
```
Morhpo, a package for landmark analysis.
ggplot2, a package for plotting data.
```
### Landmarks2Wireframe
This script reads data, performs a Procrustes and Principal Component Analysis and plots the data.

|Parameter name	|Explanation|
|---------------|-----------|
|file	|Input “dta” file. Can be uploaded in GetData in Galaxy.|
|nLandmarks	|Number of landmarks. Automatically calculated from file parameter.|
|sample_lvl	|Option which lines to plot when Species_SampleID is used. Use 1 for species and 2 for samples.|
|x_dim|	Dimension for X axis from landmark dimensions. A user can choose X, Y or Z.|
|y_dim|	Dimension for Y axis from landmark dimensions. A user can choose X, Y or Z.|
|main_title|	Title for output plot. E.G: Wireframe for 60 landmarks.|
|x_lab	|Title for X axis. E.G: Landmarks X axis.|
|y_lab	|Title for Y axis. E.G: Landmarks Y axis.|
|legend_title|	Title for legend. E.G: Species.|
|flip\_x|	Option to flip output plot horizontal. |
|flip\_y|Option to flip output plot vertical.|
|sep	|Separator for Species\_SampleID. Default is "\_"  |
|ggplot_loc|	Location to save output plot. Used by Galaxy.|
|r\_data|	Location to save RData file. This is used by other scripts, and can be imported into a RStudio worksession. Also is required for Galaxy.|

### PlotPCA_GG
PlotPCA_GG can plot principal components that are yielded from Landmarks2Wireframe. The program has the following parameters.
  
|Parameter name	|Explanation|
|---------------|-----------|
|r\_data|	Input RData file. Generated from Landmarks2Wireframe.|
|group_lvl|	Useful when the Species_SampleID format is used. This will set icons and colors to species level. Best to set this to 1.|
|speci_lvl|	This is used to set label names. Can be set to set labels to data points. Use 1 for species as label names, and 2 for specimenIDs|
|PCX| 	X dimension to show. Useful to set as 1, 2 or 3.|
|PCY|	Y dimension to show. Useful to set as 1, 2 or 3.|
|main_title|Title for output plot. E.G: PCA for 60 landmarks.|
|ggplot_loc|Location to save output plot. Used by Galaxy.|

### PlotVariance
The outputted R file from Landmarks2wireframe can be imported to calculate the percentage from the standard deviation of each principal component and plot the result. The script uses the following parameters.

|Parameter name	|Explanation|
|---------------|-----------|
|r_data|	Input RData file. Generated from Landmarks2Wireframe.|
|main_title|	Title for output plot. E.G: Variance plot.|
|ggplot_loc	|Location to save output plot. Used by Galaxy.|

## Image Processing
Image processing is performed by ConvertBackground.bash. Another example can be found in the script Examples_IM.bash. These scripts can be executed in the terminal when ImageMagick is installed. 
```
sudo apt-get install imagemagick
```

## Supplementary
The dta file that is used in the wireframe can be found here. The format for Species_SampleID used in this file.


