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
                                    geom_bar(fill='blue',position='dodge',stat="identity") +
                                      # ggplotly(ggplot(masterData,aes(x=reorder(Religion, -Population),y=Population))+
                                      # geom_bar(aes(label=Religion), fill='blue',position='dodge',stat="identity") +
                                      xlab('Religion')+ylab('Population'))
                                  },
                "percent"  =  {ggplotly(ggplot(masterData,aes(x=Religion,y=Percent))+geom_bar(fill='blue',position='dodge',stat="identity") +
                                             #  geom_bar(aes(label=Religion), fill='blue',position='dodge',stat="identity") +
                                             xlab('Religion')+ylab('Percent'))
                               }
                
                    #            "percent"     =  {ggplotly(p + geom_bar(aes(fill = bucket), position = "dodge", stat="identity") + facet_wrap(~age_group))}
         )
    
  })
}  
