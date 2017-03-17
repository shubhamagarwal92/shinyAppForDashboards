library(shiny)
source('helper.R')

# shinyUI(
ui = navbarPage("Sample Shiny Dashboard",
                tabPanel("Religion in India",
                                  # column(10, wellPanel(fluidRow(dateRangeInput('dateRnage','Choose date range', start = Sys.Date()-3, end=Sys.Date()-1, min = Sys.Date()-31, max=Sys.Date()-1)),uiOutput("ValidateDateRange"))),
                                  column(10, wellPanel(
                                    fluidRow(
                                      checkboxGroupInput("ReligionWise", "For:", inline = T,
                                                         choices = c("All" = "All", "Buddhists" = "Buddhists",
                                                                     "Christians"="Christians","Hindus"="Hindus",
                                                                     "Jains"="Jains","Muslims"="Muslims",
                                                                     "Not stated"="Not stated","Others"="Others",
                                                                     "Sikhs"="Sikhs"), 
                                                         selected = c("All","Hindus","Muslims")),
                                      # textInput("", paste0("Enter group boundaries between ", minAge," to ", maxAge), value = "18,20,22,24,26,30"),
                                      radioButtons("plotBy", "Plot Type", c("Population" = "population", "Percent" = "percent"), selected="percent")
                                    )))
                              ,column(10, plotlyOutput('plot_Religion'))

))


