library(ggplot2)
setwd('/home/clive/Desktop/GHS/breeding-app/breeding-app-backend/Data/OutputDump/')
#setwd('~/Desktop/Githubs/breeding-app/breeding-app-backend/SourceData/')
print(getwd())

df <- read.csv(file="../SourceData/CleanData.csv")
df.asatable <- read.table(file='../ASAData/Hybrid.txt', header=TRUE)

#df <- read.csv(file="allData.csv")

df$BirthYear <- with(df, format(as.Date(BirthDate, format="%Y-%m-%d"), "%Y"))

print('Calving Ease EPD')

years = c( "2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016")

epds <- c("Epds.BirthWtEpd", "Epds.YearlingWtEpd", "Epds.CeEpd", "Epds.WeanWtEpd", "Epds.Api", "Epds.Ti", "Epds.BackFatEpd")
epdNames <- c("Birth Weight", "Yearling Weight" , "Calving Ease", "Wean Weight", "API", "TI", "Back Fat")
df$Epds.BackFatEpd

i <- 1
for (epd in epds) {
  epdTrend <- c()
  for (year in years) {
    epdYearAvg <- mean(subset(df, BirthYear==year)[[epd]], na.rm=TRUE)
    epdTrend <- c(epdTrend, epdYearAvg)
  }  
  print(epdNames[i])
  print(epdTrend)
  dfepds <- data.frame(years, epdTrend)
  
  plot <- ggplot(dfepds, aes(years, epdTrend))
  plot <- plot + geom_point(color='blue', size=5, shape=21, fill="white", stroke=5) #+ stat_smooth(method="lm", col="red")
  plot <- plot + theme_classic()
  plot <- plot + ggtitle(paste("Year vs. ",epdNames[i]))
  plot <- plot + xlab("Year")
  plot <- plot + ylab(epdNames[i])
  
  png(paste("Year vs. ", epdNames[i], ".png"))
  
  print(plot)
  dev.off()
  
  i <- i + 1
}


simpledf <- data.frame(
  "CE" = df$Epds.CeEpd, 
  "BW" = df$Epds.BirthWtEpd,
  "MCE" = df$Epds.MceEpd,
  "WW" = df$Epds.WeanWtEpd,
  "YW" = df$Epds.YearlingWtEpd,
  "Marb" = df$Epds.MarblingEpd,
  "MarbAcc" = df$Epds.MarblingAcc,
  "YG" = df$Epds.YieldGradeEpd,
  "BF" = df$Epds.BackFatEpd,
  "REA" = df$Epds.RibEyeEpd,
  "SHR" = df$Epds.ShrForceEpd,
  "Stay" = df$Epds.StayEpd,
  "Milk" = df$Epds.MilkEpd,
  "MWW" = df$Epds.MwwEpd,
  "CW" = df$Epds.CarcassWtEpd,
  "Doc" = df$Epds.DocEpd,
  "ADG" = df$Epds.AdgEpd,
  "API" = df$Epds.Api,
  "TI" = df$Epds.Ti, 
  "YEAR" = df$BirthYear
)

simpledf <- simpledf[which(simpledf$YEAR=='2016'),]

epdSimpleName <- c('TI')

plot <- ggplot(simpledf, aes(API)) + geom_histogram()
print(plot)

for (epdName in epdSimpleName) {
  print(epdName)
  epdMean <- mean(simpledf[[epdName]], na.rm=TRUE)
  print(epdMean)
  print('ASA Mean')
  epdASAMean <- df.asatable[[epdName]][14]
  print(epdASAMean)
  # Select EPD Here Too
  plot <- ggplot(simpledf, aes(x=TI))
  plot <- plot + geom_histogram(binwidth=2)
  plot <- plot + geom_vline(xintercept = mean(epdMean))
  plot <- plot + geom_vline(xintercept = mean(epdASAMean), color='blue')
  plot <- plot + theme_classic()
  plot <- plot + ggtitle(paste(epdName," vs. ",'%'))
  plot <- plot + xlab(epdName)
  plot <- plot + ylab('%')
  
  print(plot)
}




