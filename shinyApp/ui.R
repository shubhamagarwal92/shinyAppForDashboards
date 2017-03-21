library(shiny)
source('helper.R')

# shinyUI(
ui = navbarPage("Sample Shiny Dashboard- Demographics of India",
                tabPanel("Literacy in India",
                         column(10, wellPanel(
                           fluidRow(
                             radioButtons("literacyPlotBy", "For", c("Males" = "males", "Females" = "females","Overall"="overall"), selected="males"),
                             mainPanel(
                               p("Used co-ordinate flipping. For plotting in increasing order, don't use order with ggplotly"),
                               p("Data from Wikipedia page doesn't include the newly formed Telangana state for this table")
                             )
                             
                           )))
                         ,column(10, plotlyOutput('plot_Literacy'))
                ),
                tabPanel("Languages in India",
                         titlePanel("Popularity of Languages"),
                         mainPanel(
                                    # "main panel",
                                   p("This wordcloud shows the most popular languages in India")
                                     # span("groups of words", style = "color:blue"),
                                     # "that appear inside a paragraph.")
                                     # 
                                   ),
                         column(10, plotOutput('plot_Language')),
                         mainPanel("Actual numbers: "),
                         column(10, tableOutput("table_Language"))
                        ),
                tabPanel("Census of India-1",
                         column(10, wellPanel(
                           fluidRow(
                             sliderInput("censusYear", "Years", 1981, 2014, value = c(1981, 2014)),
                             verbatimTextOutput("summary_Census")
                           ))),
                           column(10, plotlyOutput('plot_Census'))
                         ),
                tabPanel("Census of India-2",
                         column(10, wellPanel(
                           fluidRow(
                               radioButtons("plotByCensus", "Plot Type", c("Actual Numbers" = "population", "Rate (per 1000)" = "percent"), selected="percent"),
                               mainPanel(
                                 p("Natural Change = Live Births - Deaths"),
                                 p("Plotting all the three on the same graph can provide more information. For example,
                                   Crude Birth Rate (per 1000) has fallen from 1981 to 1982 but Crude Death Rate sees more decline 
                                   during the same year. Thus, Crude Natural Change (per 1000) increases."),
                                 p("Even though actual numbers are increasing, crude rates are on decrease"),
                                 p("Kindly take note of handle bars at the bottom to zoom in/out. Used dygraphs with shiny")
                               )
                           ))),
                         column(10, dygraphOutput('plot_DygraphCensus'))
                ),
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
                ),
                    tabPanel("Sex Ratio in India",
                             column(10, wellPanel(
                               fluidRow(
                                 mainPanel(
                                   p("Creating choropleth map in R. Data projection is a bit disoriented because of Shiny. Working fine on local"),
                                   p("The map shows Sex Ratio prevailing in different states of India"),
                                   p("It takes some time to load the data. Please wait...Don't close! :P ggplot itself takes a 
                                     lot of time (even though we have a saved final dataframe) with addition woes of ggplotly and shiny"),
                                   p("Kindly note that the shape file is taken from http://www.diva-gis.org/gdata. 
                                     The geographical boundaries may not be respected as observed by Indian Government.")
                                 )
                               )
                             )
                             ),
                            column(12, plotlyOutput('plot_SexRatio'))
                              )
)
                



