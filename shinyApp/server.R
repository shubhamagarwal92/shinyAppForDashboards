library(shiny)
source('helper.R')

getReligionData <- function (fileName) {
  if(!file.exists(fileName)){
    source('wikiTable.R')
  }
  tmpdata = read.csv(fileName)
  tmpdata
}  
# df=read.csv(file = "religion.csv")
# Function to get data between particular date ranges where file name exists by date
# getDailyData <- function (OnDate) {
#   fileName = paste0(CachedFileLocations_Stats, as.character(OnDate), '.txt')
#   if(!file.exists(fileName)){
#     day =(as.numeric(Sys.Date() - as.Date(OnDate))-1)
#     command =  paste0(pythonCommand,"getData.py",' ',day,' ',day+1)
#     system(command)
#   }
#   tmpdata = read.table(fileName, header=F, sep = "\t")
#   tmpdata
# date1 = as.Date(as.POSIXct("2016-01-01"))
# date2 = as.Date(as.POSIXct("2016-01-07"))
# getReactiveData <- function(displayStr, getOnDateDataFunction, date1, date2){
#   withProgress(message = 'Calculation in progress',
#                detail = 'This may take a while...', value = 0, { 
#                  timeSeq = seq(from = date1, to=date2, length = 1+(date2-date1))
#                  masterData = NULL
#                  for(t in 1:length(timeSeq)){
#                    incProgress(1/length(timeSeq), detail = paste0("Computing ",displayStr," for date ", timeSeq[t]))
#                    masterData = rbind(masterData, getOnDateDataFunction(timeSeq[t]))
#                  }
#                  masterData
#                })
# }

server <- function(input, output) {
  
  ReligionData = reactive({
    masterData = getReligionData("religion.csv")
    # masterData = getReactiveData("displayStr", getData, input$dateRange[1], input$dateRange[2])
    # Other processing here
    # masterData$dateQuery = as.Date(as.POSIXct(masterData$dateQuery))
    masterData = masterData %>% filter(Religion %in% input$ReligionWise)
  })
  
  output$plot_Religion<-renderPlotly({
    masterData = ReligionData()
        switch(input$plotBy,
                "population"  =  {ggplotly(ggplot(masterData,aes(x=Religion,y=Population))+
                                    geom_bar(fill='blue',position='dodge',stat="identity",colour="black") +
                                      # ggplotly(ggplot(masterData,aes(x=reorder(Religion, -Population),y=Population))+
                                      # geom_bar(aes(label=Religion), fill='blue',position='dodge',stat="identity") +
                                      xlab('Religion')+ylab('Population'))
                                  },
                "percent"  =  {ggplotly(ggplot(masterData,aes(x=Religion,y=Percent))+geom_bar(fill='blue',position='dodge',stat="identity",colour="black") +
                                             #  geom_bar(aes(label=Religion), fill='blue',position='dodge',stat="identity") +
                                             xlab('Religion')+ylab('Percent'))
                               }
         )
    
  })
  
  LanguageData = function(){
    masterData = getReligionData("Languages.csv")
    masterData
  }
  
  output$plot_Language <- renderPlot({
    dfLang = LanguageData()
    wordcloud(words = dfLang$Language, freq = dfLang$Speakers, min.freq = 1,scale=c(6,2),
              max.words=200, random.order=FALSE, rot.per=0.35,
              colors=brewer.pal(8, "Dark2"))
  })
  output$table_Language <- renderTable({
    dfLang = LanguageData()
    dfLang %>% select(Language,Speakers)
  })
  
  CensusDataOriginal = function(){
    censusData = getReligionData("Census.csv")
    censusData
  }
  CensusData = reactive({
    censusData = CensusDataOriginal()
    censusData$Year = as.numeric(censusData$Year)
    masterData = censusData %>% filter(between(Year, input$censusYear[1], input$censusYear[2]))
    names(masterData)[2] = "AvgPopulation"
    masterData
  })
  
  output$summary_Census <- renderPrint({
    masterData = CensusData()
    paste0("Total Change in Avg Population for selected range = ",masterData$AvgPopulation[nrow(masterData)] - masterData$AvgPopulation[1], " X 1000" )
    # nrow(masterData)
    })
  
  output$plot_Census <- renderPlotly({
    masterData = CensusData()
  # masterData <- melt(masterData,
  #                   # ID variables - all the variables to keep but not split apart on
  #                   id.vars=c("Year"),
  #                   # The source columns
  #                   measure.vars=c("Births", "Deaths"),
  #                   # Name of the destination column that will identify the original
  #                   # column that the measurement came from
  #                   variable.name="condition",
  #                   value.name="measurement"
  # )
  ggplotly(ggplot(data=masterData, aes(x=Year, y=AvgPopulation)) +
    geom_line(color="lightpink4") +  scale_fill_manual(values=c("#CC6666")) +
    geom_point(color="firebrick")+xlab('Year')+ylab('Average Population (X 1000)'))
  

  })
  

  output$plot_DygraphCensus <- renderDygraph({
    # dygraph(masterData %>% select(Year,Births,Deaths,Change))%>%
    # # dySeries("mdeaths", label = "Male") %>%
    # # dySeries("fdeaths", label = "Female") %>%
    # # dyOptions(stackedGraph = TRUE) %>%
    # dyRangeSelector(height = 20)
    masterData = CensusDataOriginal()
    switch(input$plotByCensus,
           "population"  =  {    dygraph(masterData %>% select(Year,Births,Deaths,Change))%>%
                                 dyRangeSelector(height = 20)
             
           },
           "percent"  =  {   dygraph(masterData %>% select(Year,BirthRate,DeathRate,ChangeRate))%>%
                             dyRangeSelector(height = 20)
             
           }
    )
    
  })

  LiteracyData = reactive({
    dfLiteracy = getReligionData("Literacy.csv")
    dfLiteracy 
  })
  
  output$plot_Literacy<-renderPlotly({
    dfLiteracy = LiteracyData()
    switch(input$literacyPlotBy,
           "males"  =  {
                        dfLiteracy$state <- factor(dfLiteracy$state, levels = dfLiteracy$state[order(dfLiteracy$male)])
                        # Don't use reorder with ggplotly
                        # ggplotly(ggplot(dfLiteracy,aes(x=reorder(state,male),y=male))+ coord_flip() +
                        #         geom_point(color="firebrick")+xlab('States (UTs)')+ylab('Literacy Rate (in %)'))
                        ggplotly(ggplot(dfLiteracy,aes(x=state,y=male))+ coord_flip() +
                                   geom_point(color="firebrick")+xlab('States (UTs)')+ylab('Literacy Rate (in %)'))
             
           },
           "females"  =  {
                           dfLiteracy$state <- factor(dfLiteracy$state, levels = dfLiteracy$state[order(dfLiteracy$female)])
                           ggplotly(ggplot(dfLiteracy,aes(x=state,y=female))+ coord_flip() +
                                      geom_point(color="firebrick")+xlab('States (UTs)')+ylab('Literacy Rate (in %)'))
                           
           },
           "overall"  =  {
                           dfLiteracy$state <- factor(dfLiteracy$state, levels = dfLiteracy$state[order(dfLiteracy$overall)])
                           ggplotly(ggplot(dfLiteracy,aes(x=state,y=overall))+ coord_flip() +
                                      geom_point(color="firebrick")+xlab('States (UTs)')+ylab('Literacy Rate (in %)'))
                           
           }
    )
    
  })
  
  
  SexRatioData = function(){
    masterData = getReligionData("finalplot.csv")
    masterData
  }
  
  output$plot_SexRatio <- renderPlotly({
    final.plot = SexRatioData()
    cnames <- aggregate(cbind(long, lat) ~ NAME_1, data=final.plot, FUN=function(x) mean(range(x)))
    
    ggplotly(ggplot() + geom_polygon(data = final.plot, 
                            aes(x = long, y = lat, group = group, fill = SexRatio), 
                            color = "black", size = 0.25) + coord_map()+
               scale_fill_distiller(name="Sex Ratio", palette = "YlGn", breaks = pretty_breaks(n = 5))+
               labs(title="Sex Ratio in India")+xlab("")+ylab("")+
               geom_text(data=cnames, aes(long, lat, label = NAME_1), size=3, fontface="bold")
            )
  })
  
}  
