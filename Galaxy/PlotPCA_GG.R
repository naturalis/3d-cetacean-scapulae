# 03-05-2017: Sebastiaan de Vriend
# Plotting PCA on Species level.
library(plyr)
library(ggplot2)


detect_groups <- function(samplenames, level, sep="_"){
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
  # The result is returned as a vector
  level <- as.integer(level) # Galaxy input is in string format...
  groups_raw <- NULL
  for (name in samplenames){
    groups_raw <- c(groups_raw, unlist(strsplit(name, sep))[level])
  }
  groups_uniq <- unique(groups_raw)
  freqs <- count(groups_raw )
  freqs <- freqs[match(groups_uniq, freqs$x),]
  # Loop through the length of the frequences.
  for (item in 1:length(freqs[,1])){
    name <- as.character(freqs$x[item])
    if (item == 1){
      startpos <- 1
      endpos <- freqs$freq[item]
      groups <- list(c(startpos, endpos, name))
    }
    else{
      startpos <- endpos + 1
      endpos <- endpos + freqs$freq[item]
      groups[[item]] <- c(startpos, endpos, name)
    }
  }
  group_vector <- c()
  for (member in groups){
    group_vector <-c(group_vector, rep(member[3], (as.integer(member[2]) - as.integer(member[1]) + 1)))
  }
  return(group_vector)
}



plot_pca <- function(r_data, Group_lvl, Speci_lvl, PCX, PCY, plot_title, plot_loc){
  # Input: 7
  #   r_data: Location for r data file.
  #   group_lvl: Integer: Index for group level.
  #   Speci_lvl: Integer: Index for specimen level.
  #   PCX: Integer for PCA Dimension on X-Axis.
  #   PCY: Integer for PCA Dimension on Y-Axis.
  #   plot_title: String, name for plot.
  #   plot_loc: Location to save plot file to.
  #
  # The function loads in a r file with the variable procPCA.
  # From this variable, the PCScores are extracted to a dataframe.
  # Then, two columns are added. Species and Samplenames. This is done
  # by detect_groups and the corresponding group index.
  # Then, two variables are assigned to be used in ggplot aes_string.
  # This is used to assign variables in ggplot.
  #
  # After that, the data is plotted and saved on gg_loc.
  load(r_data)
  # Data to dataframe
  dfPCA <- as.data.frame(procPCA$PCscores)
  # Add species name to dataframe
  dfPCA$Species <- detect_groups(row.names(dfPCA), Group_lvl)
  # Add samplename to dataframe
  dfPCA$Sample_names <- detect_groups(row.names(dfPCA), Speci_lvl)
  
  PCX <- paste("PC", PCX, sep="")
  PCY <- paste("PC", PCY, sep="")
  Species <- "Species"
  Sample_names <- "Sample_names"
  # plot data
  pca_plot <- ggplot(data=dfPCA, aes_string(x=PCX, y=PCY, shape=Species, colour=Species, label=Sample_names)) + geom_point() +
    geom_text(size=3, position = position_nudge(y = -0.001), show.legend = F) + 
    ggtitle(plot_title) + 
    theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0.5)) +
    theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=12))
  # Save plot
  png(plot_loc, width=800, height=720)
  invisible(capture.output(print(pca_plot)))
  invisible(capture.output(dev.off()))
}



main <- function(args){
  test_data <- F
  if(!test_data){
    r_data <- args[1]
    group_lvl <- args[2]
    speci_lvl <- args[3]
    PCX <- args[4]
    PCY <- args[5]
    main_title <- args[6]
    plot_loc <- args[7]
  }
  else if(test_data){
    r_data <- ""
    group_lvl <- 1
    speci_lvl <- 2
    PCX <- 1
    PCY <- 2
    main_title <- "Titel voor barplot"
    plot_loc <- "Locatie voor plot"
  }
  plot_pca(r_data, group_lvl, speci_lvl, PCX, PCY, main_title, plot_loc)
}

main(commandArgs(T))


