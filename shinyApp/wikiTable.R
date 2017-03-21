require(XML)
require(httr)
# Crawling data from wikipedia
tables <- GET("https://en.wikipedia.org/wiki/Demographics_of_India")
tables <- readHTMLTable(rawToChar(tables$content))
names(tables)

convertToNumberFromCommaSepString = function(colValues){
  colValues = as.numeric(gsub(",", "", colValues, fixed = TRUE))
  colValues
}
## Religion
# We are plotting the religion of the population
df = tables[[6]]
# print(df)
# Population data is crawled as string separated by comma
# gsub removes all the instances of comma
df$Population = as.numeric(gsub(",", "", df$Population, fixed = TRUE))
# Convert the percent also in numeric form
df$`Percent (%)` = as.numeric(as.character(df$`Percent (%)`))
# Column names
names(df)[3] = 'Percent'
# Write to csv
write.csv(df,file="religion.csv",row.names = FALSE)

## Languages
dfLang = tables[[13]]
dfLang$Speakers = as.numeric(gsub(",", "", dfLang$Speakers, fixed = TRUE))
dfLang$Language = as.character(dfLang$Language)
dfLang$Language[1] = "Hindi"
write.csv(dfLang,file="Languages.csv",row.names = FALSE)

## Census
dfCensus = tables[[16]]
names(dfCensus) = c("Year","AvgPop","Births","Deaths","Change","BirthRate","DeathRate","ChangeRate","FertilityRate")
dfCensus$AvgPop = convertToNumberFromCommaSepString(dfCensus$AvgPop)
dfCensus$Births = convertToNumberFromCommaSepString(dfCensus$Births)
dfCensus$Deaths = convertToNumberFromCommaSepString(dfCensus$Deaths)
dfCensus$Change = convertToNumberFromCommaSepString(dfCensus$Change)
dfCensus$BirthRate = convertToNumberFromCommaSepString(dfCensus$BirthRate)
dfCensus$DeathRate = convertToNumberFromCommaSepString(dfCensus$DeathRate)
dfCensus$ChangeRate = convertToNumberFromCommaSepString(dfCensus$ChangeRate)
dfCensus$Year = convertToNumberFromCommaSepString(dfCensus$Year)
dfCensus = dfCensus[1:nrow(dfCensus)-1,]

  
dfCensus$Year = as.numeric(dfCensus$Year)
write.csv(dfCensus,file="Census.csv",row.names = FALSE)

## Literacy Rate
dfLiteracy = tables[[12]]
names(dfLiteracy) = c("rank","state","overall","male","female")
dfLiteracy$overall = convertToNumberFromCommaSepString(dfLiteracy$overall)
dfLiteracy$male = convertToNumberFromCommaSepString(dfLiteracy$male)
dfLiteracy$female = convertToNumberFromCommaSepString(dfLiteracy$female)
# dfLiteracy = dfLiteracy[1:nrow(dfLiteracy)-1,]
write.csv(dfLiteracy,file="Literacy.csv",row.names = FALSE)

## Sex Ratio
states.shp <- readShapeSpatial("IND_adm/IND_adm1.shp")
names(states.shp)
states.shp.f <- fortify(states.shp, region = "ID_1")
class(states.shp.f)
df = tables[[4]]
# print(df)
# Population data is crawled as string separated by comma
# gsub removes all the instances of comma

myData = df %>% select(c(2,7))
myData = myData[1:36,]
names(myData) = c("State","SexRatio")
myData$SexRatio = as.numeric(as.character(myData$SexRatio))
myData = myData[order(myData$State),]

mydata<-data.frame(NAME_1=states.shp$NAME_1, id=states.shp$ID_1, SexRatio=myData$SexRatio)
# head(mydata)

merge.shp.coef<-merge(states.shp.f, mydata, by="id", all.x=TRUE)
final.plot<-merge.shp.coef[order(merge.shp.coef$order), ] 
write.csv(final.plot,file="finalplot.csv",row.names = FALSE)

