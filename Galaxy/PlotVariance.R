# 03-05-2017: Sebastiaan de Vriend
# This script plots the variance of the principal components in the 3DPCA Pipline for scapulae
library(ggplot2)

plotvariance <- function(r_data, main_title, ploc_loc){
  # Input: 3
  #   r_data: Location of R data file supplied in Galaxy or created by Landmarks2Wireframe
  #   main_title: Title for plot
  #   plot_loc: Location to save plot on disk
  #
  # The function loads in the procPCA variable where the procrustes
  # and PCA is located.
  # The variance calculation is based on the pipeline of Mirna baak.
  #
  # The variance is stored into a dataframe, and plotted into ggplot
  #
  load(file=r_data)
  # Transform data
  stdev <- procPCA$eigenvalues
  PercVar <- stdev^2/sum(stdev^2)
  dfPercVar <- as.data.frame(PercVar)
  dfPercVar$range <- c(1:length(PercVar))
  # Plot data
  varplot <- qplot(x=range, y=PercVar, fill=PercVar, data=dfPercVar) + 
    geom_bar(stat="identity", position="dodge") + 
    scale_x_continuous(breaks = seq(1, length(PercVar))) + 
    # Set labels y axis from 0.1 till 1.0 by increments of 0.1
    scale_y_continuous(breaks = seq(0.0, 1.0, 0.1), limits=c(0, 1.0))+
    labs(x="Principal components", y="% Variance") + 
    ggtitle(main_title) + 
    # Remove legend from plot
    theme(legend.position="none") +
    theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0.5)) +
    theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=12))
  # save plot to image file
  png(ploc_loc, width=800, height=720)
  invisible(capture.output(print(varplot)))
  invisible(capture.output(dev.off()))
}
  

main <- function(args){
  # If testdata is set to true, then all variables have to be set in the else if statement.
  test_data <- F
  if(!test_data){
    r_data <- args[1]
    main_title <- args[2]
    plot_loc <- args[3]
  }
  else if(test_data){
    r_data <- "~/Data.RData" # Location for Rdata file
    main_title <- "Barplot title"
    plot_loc <- "~/Plots" # plot save location
  }
  plotvariance(r_data, main_title, plot_loc)
}

main(commandArgs(T))