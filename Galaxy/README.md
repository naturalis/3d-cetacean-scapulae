# Galaxy
This folder contains the scripts and xml files that are used in Galaxy. A temporary Galaxy is set online and can be tested with a supplementary file (http://145.136.241.84:8080/). 

Please place tools in the tools folder in galaxy and edit the tool_conf.xml in the config folder.

## Install_R-packages
This script can be used to install packages that are required by the Galaxy pipeline. It is advised to run this script in the shell environment. The script installs:
```
Morhpo, a package for landmark analysis.
ggplot2, a package for plotting data.
```
## Landmarks2Wireframe
This script reads data, performs a Procrustes and a Principal Component Analysis. The result is plotted as a wireframe plot.

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

## PlotPCA_GG
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

## PlotVariance
The outputted R file from Landmarks2wireframe can be imported to calculate the percentage from the standard deviation of each principal component and plot the result. The script uses the following parameters.

|Parameter name	|Explanation|
|---------------|-----------|
|r_data|	Input RData file. Generated from Landmarks2Wireframe.|
|main_title|	Title for output plot. E.G: Variance plot.|
|ggplot_loc	|Location to save output plot. Used by Galaxy.|
