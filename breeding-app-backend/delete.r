library(ggplot2)
setwd('/home/clive/Desktop/GHS/breeding-app/breeding-app-backend')
print(getwd())

df <- read.csv(file="CleanData.csv")
print(df$BirthDate[1])

df$BirthYear <- with(df, format(as.Date(BirthDate, format="%Y-%m-%d"), "%Y"))

