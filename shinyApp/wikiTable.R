require(XML)
require(httr)
# Crawling data from wikipedia
tables <- GET("https://en.wikipedia.org/wiki/Demographics_of_India")
tables <- readHTMLTable(rawToChar(tables$content))
names(tables)
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
