library(ggplot2)
setwd('/home/clive/Desktop/GHS/breeding-app/breeding-app-backend')
print(getwd())

df <- read.csv(file="CleanData.csv")

df$BirthYear <- with(df, format(as.Date(BirthDate, format="%Y-%m-%d"), "%Y"))

print('Calving Ease EPD')

years = c( "2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016")

epds <- c("Epds.BirthWtEpd", "Epds.YearlingWtEpd", "Epds.CeEpd", "Epds.WeanWtEpd", "Epds.Api", "Epds.Ti")
epdNames <- c("Birth Weight", "Yearling Weight" , "Calving Ease", "Wean Weight", "API", "TI")
df$Epds.WeanWtEpd

i <- 0
for (epd in epds) {
  epdTrend <- c()
  for (year in years) {
    epdYearAvg <- mean(subset(df, BirthYear==year)[[epd]], na.rm=TRUE)
    epdTrend <- c(epdTrend, epdYearAvg)
  }  
  
  dfepds <- data.frame(years, epdTrend)
  
  plot <- ggplot(dfepds, aes(years, epdTrend))
  plot <- plot + geom_point(color='blue', size=5, shape=21, fill="white", stroke=5) #+ stat_smooth(method="lm", col="red")
  #plot <- plot + geom_bar(stat="identity")
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
  "TI" = df$Epds.Ti
)

#print(cor(simpledf, use="complete.obs", method="pearson"))

fitBW <- lm(API ~ BW, data=simpledf, na.action=na.omit)
fitCE <- lm(API ~ CE, data=simpledf, na.action=na.omit)
fitMarb <- lm(API ~ Marb, data=simpledf, na.action=na.omit)
fitStay <- lm(API ~ Stay, data=simpledf, na.action=na.omit)

BWAPIPred <- simpledf$BW*fitBW$coefficients[2] + fitBW$coefficients[1]
CEAPIPred <- simpledf$CE*fitCE$coefficients[2] + fitCE$coefficients[1]
MarbAPIPred <- simpledf$Marb*fitMarb$coefficients[2] + fitCE$coefficients[1]
StayAPIPred <- simpledf$Stay*fitStay$coefficients[2] + fitStay$coefficients[1]

BWWeight <- 1.0
CEWeight <- 1.1
MarbWeight <- 2.1
StayWeight <- 1.7

WeightSum <- BWWeight + CEWeight + MarbWeight + StayWeight

meanAPIPred <- ((BWAPIPred * BWWeight) + (CEAPIPred*CEWeight) + (MarbAPIPred*MarbWeight) + (StayAPIPred*StayWeight)) / WeightSum

simpledf$APIPredictor <- meanAPIPred

plot <- ggplot(simpledf, aes(x=meanAPIPred, y=API))
plot <- plot + geom_point(color='blue') #+ stat_smooth(method="lm", col="red")
plot <- plot + theme_classic()
plot <- plot + ggtitle("API Prediction vs. Actual")
plot <- plot + xlab("API Prediction")
plot <- plot + xlim(c(75, 175))
plot <- plot + ylim(c(75, 175))

#print(plot)

print(cor(simpledf$API, simpledf$APIPredictor, use="complete.obs", method="pearson"))

