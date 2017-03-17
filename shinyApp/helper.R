# Install the packages for all users 
# sudo su - -c "R -e \"install.packages(c('shiny'), repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages(c('plotly'), repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages(c('ggplot2'), repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages(c('dplyr'), repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages(c('scales'), repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages(c('grid'), repos='http://cran.rstudio.com/')\""
# sudo su - -c "R -e \"install.packages(c('RMySQL'), repos='http://cran.rstudio.com/')\""
library(dplyr)
library(plotly)
library(ggplot2)
library(scales)
library(grid)
library(RMySQL)
library(reshape2)

# Adding these functions which proved useful 
# Querying
# getQueryData <- function (query) {
#   print("Creating Connection")
#   mydb = dbConnect(MySQL(), user='', password='', dbname='', host='')
#   print("Running the Query")
#   rs = suppressWarnings(dbSendQuery(mydb, query))
#   print("fetching  the Results")
#   data = fetch(rs, n=-1)
#   suppressWarnings(dbDisconnect(mydb))
#   data
# }
# Run python if needed  
# pythonCommand = paste0("/usr/bin/python cron_file.py")

# To load data from different directory
# CachedFileLocations = ''
# getNewLocation <- function(dirName){
#   paste0(CachedFileLocations, dirName, '/')
# }
# fileLocation = getNewLocation('Stats')
# df = read.csv(file=fileLocation)

