#
# Sebastiaan de Vriend 02-05-2017: sebastiaandevriend@gmail.com
# This script plots landmarks on a wireframe with a meanline.
# The script will work in Galaxy and is an aditional option to the procrustus PCA.
# ggplot2 and morpho are used.
options(rgl.useNULL=TRUE)
library(ggplot2)
library(Morpho)
library(plyr)


calc_mean_group <- function(pcaloadings, nLandmarks){
  # Input: 2
  # pcaloadings: list created by showPC function.
  # nLandmarks: integer: Number of landmarks. Used in the loop.
  #
  # The function calculates for each landmark the mean position of the group.
  # This is applied for each dimension. This is not applied when the provided
  # matrix is a 2D matrix instead of 3D. (In 2D, only 1 sample is prodided.)
  # In the for loop. Each row is appended to the mean matrix.
  #
  # This matrix is returned as a dataframe for ggplot2.
  for (i in 1:nLandmarks){
    if (length(dim(pcaloadings)) == 2){
    tempMatrix <- matrix(c(pcaloadings[i, 1,  drop=F], 
                           pcaloadings[i, 2,  drop=F],
                           pcaloadings[i, 3,  drop=F]), ncol=3)
    }
    else if (length(dim(pcaloadings)) == 3){
      tempMatrix <- matrix(c(mean(pcaloadings[i, 1, ,drop=F]), 
                             mean(pcaloadings[i, 2, ,drop=F]),
                             mean(pcaloadings[i, 3, ,drop=F])), ncol=3)
    }
    if (i==1){
      meanmatrix <- tempMatrix
    }
    else{
      meanmatrix <- rbind(meanmatrix, tempMatrix)
    }
  }
  return (as.data.frame(meanmatrix))
}

detect_groups <- function(samplenames, level, sep = "_"){
  # Input: 3
  # Samplenames: From fileread file$dimnames
  # Leven of extraction in '_'. Can only be applied when _ is used.
  # sep: string seperator. Can be overrided.
  #
  # The function counts frequences of strings to create groups.
  # In the loop, the function creates a starting and end position for each
  # group member. This will create groups automaticly, and is used to
  # select groups for each wireframe.
  #
  # The frequency table is sorted by the unique values of the sample input.
  # This preservers the correct order.
  #
  # The result is returned as a list.
  level <- as.integer(level) # Galaxy input is in string format...
  groups_raw <- NULL
  group_name_raw <- NULL
  for (name in samplenames){
    groups_raw <- c(groups_raw, unlist(strsplit(name, sep))[level])
    group_name_raw <- c(group_name_raw, unlist(strsplit(name, sep))[1])
  }
  groups_uniq <- unique(groups_raw)
  freqs <- count(groups_raw )
  freqs <- freqs[match(groups_uniq, freqs$x),]
  # Loop through the length of the frequences.
  for (item in 1:length(freqs[,1])){
    if (level == 1){
      group_name <- as.character(freqs$x[item])
    }
    else if (level == 2){
      group_name <- group_name_raw[item]
    }
    name <- as.character(freqs$x[item])
    if (item == 1){
      startpos <- 1
      endpos <- freqs$freq[item]
      groups <- list(c(startpos, endpos, name, group_name))
    }
    else{
      startpos <- endpos + 1
      endpos <- endpos + freqs$freq[item]
      groups[[item]] <- c(startpos, endpos, name, group_name)
    }
  }
  return(groups)
}

getLandmarks2Wireframe <- function(landmarksfile, sample_lvl, nLandmarks, x_dim, y_dim, sep="_", r_data){
  # Input: 6
  #   landmarksfile: object containing landmarks in IDAV landmarker format (.dta)
  #   sample_lvl: Level in which to extract samplenames. 1 for group. 2 for individuals.
  #   nLandmarks: Integer. Number of landmarks.
  #   x_dim: integer of which dimension is X dimension (1, 2 or 3).
  #   y_dim: integer. Same as X, but then for Y dimension.
  #   sep: seperator for detect groups function. Can be overrided.
  #
  # The function performs a procrustus and PCA. It then extracts the mean shape of the procrustus.
  # The landmarks in PCA orientation are extracted from showPC.
  # Data that are needed for ggplot is obtained from the loop that iterates through group members.
  # Also data are converted to dataframe, as ggplot does not support matrices.
  #
  # The function returns the mean shape and the group data as list.
  # Also returns procPCA for other plots.

  # Perform procrustus and PCA.
  invisible(capture.output(procPCA <- procSym(landmarksfile$arr, reflect = F)))
  # Get mean shape coords.
  dfmean <- as.data.frame(procPCA$mshape[1:nLandmarks, c(x_dim, y_dim)])
  # Landmarks in PCA
  pcaloadings <- showPC(scores = procPCA$PCscores, PC = procPCA$PCs, mshape = procPCA$mshape)
  # get groups 
  groups <- detect_groups(landmarksfile$idnames, sample_lvl, sep)
  # Get data for groups
  dftotalgroups <-NULL
  for (group in groups){
    # Get average of group.
    df_3Dmean_group <- calc_mean_group(pcaloadings = pcaloadings[,,group[1]:group[2]], nLandmarks)
    # Add group name to group
    df_3Dmean_group$Name <- group[3]
    df_3Dmean_group$Group_name <- group[4]
    # Bind df_3Dmean_group to total dataframe on row.
    dftotalgroups <- rbind(dftotalgroups, df_3Dmean_group)
  }
  # Get dimension data and names.(This is always 4: X, Y, Z, Name)
  filterdgroups <- dftotalgroups[,c(x_dim, y_dim, 4, 5)]
  save(procPCA, file=r_data) # Save variable for plotting in other modules
  return (list(dfmean, filterdgroups))
}

eval_dim <- function(var_dim){
  # Input: 1
  # var_dim: Character X Y or Z.
  # The function performs a if statement and
  # returns the indexes for x y or z.
  # if none is provided, an error is raised.
  if (var_dim == "X"){
    var_dim_new <- 1
    var_dat <- "V1"
  } else if (var_dim == "Y"){
    var_dim_new <- 2
    var_dat <- "V2"
  } else if (var_dim == "Z"){
    var_dim_new <- 3
    var_dat <- "V3"
  } else{
    stop("NO X, Y, OR Z index found. please insert a X, Y or Z in the variable dim")
  }
  return (c(var_dim_new, var_dat))
}

landmarks2wireframe <- function(landmarksfile, sample_lvl, nLandmarks, x_dim, y_dim, main_title,
                                x_lab, y_lab, legend_title, flip_x, flip_y, sep="_", ggplot_loc, r_data){
  # Input 12:
  #   landmarksfile: File with landmarks.
  #   sample_lvl: lvl to extract samples.
  #   n_landmarks: number of landmarks.
  #   x_dim: X Y or Z string. used in plot and data.
  #   y_dim: Same as x_dim.
  #   main_title: Title for plot.
  #   x_lab: Title for X axis.
  #   y_lab: Title for Y axis.
  #   Legend_title: title for legend. if provided...
  #   flip_x: Bool to flip X axis.
  #   flip_y: Bool to flip Y axis. <- more usefull.
  #
  # Large function that collects and plots the data for a wireframe.

  # Get indexes for X axis. EG: Column V1 for dataframe filtered groups
  x_dim_val <- eval_dim(x_dim) # Vector
  x_dim_new <- as.integer(x_dim_val[1]) # Integer
  x_dat <- x_dim_val[2] # String
  # Get indexes for Y axis.
  y_dim_val <- eval_dim(y_dim) # Vector
  y_dim_new <- as.integer(y_dim_val[1]) # Integer
  y_dat <- y_dim_val[2] # string
  # Get data for plot
  landmarksoutput <- getLandmarks2Wireframe(landmarksfile=landmarksfile, sample_lvl=sample_lvl,
                                           nLandmarks=nLandmarks, x_dim=x_dim_new, y_dim=y_dim_new, sep, r_data)
  dfmean <- landmarksoutput[[1]]
  filterdgroups <- landmarksoutput[[2]]
    # Create GG plot
  wireframeplot <- ggplot(dfmean, aes(x = V1, y = V2, colour="Meanshape")) + 
    geom_point(data = filterdgroups, aes_string(x = x_dat, y=y_dat, colour ="Group_name"), size=3)  + 
    geom_path(data = filterdgroups, aes_string(x = x_dat, y=y_dat, group="Name", colour ="Group_name"), size=1.5) +
    geom_point(data = dfmean, aes(x = V1, y = V2, colour="Meanshape") , size=3)+
    geom_path(data = dfmean, aes(x = V1, y = V2, colour="Meanshape"), size=1.5 )+
    geom_text(aes(label = 0:(nLandmarks-1)),  colour="Black", show.legend=F, size=4, fontface = "bold") +
    scale_colour_discrete(name=legend_title) +
    ggtitle(main_title) + 
    labs(x=x_lab, y=y_lab) +
    theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0.5)) +
    theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16)) +
    theme(legend.text = element_text(size = 12) ) +
    theme(legend.title = element_text(size=14, face="bold"))
  
  # This if statement flips the plot if one of the variables is set to TRUE in string format.
  if(flip_x == "TRUE"){
    wireframeplot <- wireframeplot + coord_flip()
  }else if(flip_y == "TRUE"){
    wireframeplot <- wireframeplot + scale_y_reverse()
  }
  png(ggplot_loc, width=800, height=720)
  invisible(capture.output(print(wireframeplot)))
  invisible(capture.output(dev.off()))
}

main <- function(args){
  test_data <- F # Set to T for standalone.
  if (!test_data){
    # Read input file
    file <- read.lmdta(args[1])
    # get number of landmarks
    nLandmarks <- as.integer(file$info[3])/3
    # sample lvl: 1 for groups, 2 for species lvl if groups avaiable.
    sample_lvl <- args[2]
    # x dimension: X Y or Z
    x_dim <-args[3]
    # y dimension: X Y or Z
    y_dim <- args[4]
    # Title for plot
    main_title <- args[5]
    # title x axis
    x_lab <- args[6]
    # title y axis
    y_lab <- args[7]
    # custom title for legend
    legend_title <- args[8]
    # bool: to flip x axis
    flip_x <- args[9]
    # bool to flip y axis
    flip_y <- args[10]
    # custom seperator. "_" is standard.
    sep <- args[11]
    # ggplot
    ggplot_loc <- args[12]
    # Save proc var location
    r_data <- args[13]
  }
  if (test_data){
    setwd("D:/Dropbox/hbo/Naturalis/Pipeline/Key_data/") # Set directory where dta file is located
    file <- read.lmdta("C-Dolphin_Harbour-P_whitebkd-D_60landmarks_curves-only.dta") # input dta file
    sample_lvl <- 1 # sort by species (1) or by specimens (2). 
    nLandmarks <- as.integer(file$info[3])/3
    x_dim <- "X"
    y_dim <- "Y"
    main_title <- "Wireframe per group 60 landmarks"
    x_lab <- "Landmarks X-Axis"
    y_lab <- "Landmarks Y-Axis"
    legend_title <- "Species"
    # FLip plot on x or y axis. Set to str TRUE
    flip_y <-"FALSE"
    flip_x <- "FALSE"
    sep <- "_"
    ggplot_loc <- paste(getwd(), "/wireframe_v3.png", sep="")
    r_data = "ProcustesPCA.Rdata"
  }
  landmarks2wireframe(file, sample_lvl, nLandmarks, x_dim, y_dim, main_title, x_lab, y_lab, legend_title,
                      flip_x, flip_y, sep, ggplot_loc, r_data)
}

main(commandArgs(T))
