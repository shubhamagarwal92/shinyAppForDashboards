# shinyAppForDashboards
This repository contains a sample shiny app (using shiny in R) to prepare dashboards. Very powerful for visualisation using ggplot (ggplotly) in R. We also scrape the religion statistics in India from wikipedia for visualization. Read further for more description.

ShinyApps provide the feature of deploying your app. You can find a running instance of this app at https://shubhamagarwal92.shinyapps.io/shinyapp/ 

## Requirements

ggplotly provides interactiveness when used with Shiny. Thus requied R packages that can come in handy for using R are: 

###R packages

```bash
sudo su - -c "R -e \"install.packages(c('shiny'), repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages(c('plotly'), repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages(c('ggplot2'), repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages(c('dplyr'), repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages(c('scales'), repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages(c('grid'), repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages(c('RMySQL'), repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages(c('rsconnect'), repos='http://cran.rstudio.com/')\""
```
I found this command useful to install packages for all users on AWS. (Otherwise use install.packages from R). 

rsconnect allows to deploy the app on shinyapp.io

## Description

We scrape the tables from [wikipedia](https://en.wikipedia.org/wiki/Demographics_of_India) and store them as religion.csv 

helper.R can be used for defining global variables or library imports

ui.R server.R same as for a shiny app. Read more from [shiny documentation](http://rstudio.github.io/shiny/tutorial/)

Personally, I would recommend using dplyr package for filtering and other operations in R. 

Feel free to explore more about this app at shinyapps.io 
