library(ggplot2)
setwd('/home/clive/Desktop/GHS/breeding-app/breeding-app-backend/')
#setwd('~/Desktop/Githubs/breeding-app/breeding-app-backend/SourceData/')
print(getwd())

df <- read.csv(file="CleanData.csv")
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
  
  png(paste("XYear vs. ", epdNames[i], ".png"))
  
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


apiFullPrediction <- lm(API~ CE + BW + MCE + WW + YW + Marb + YG + BF + REA + SHR + Stay + Milk + MWW + CW + Doc + ADG, data = simpledf, na.action=na.omit)
apiFullPredictionNoShr <- lm(API~ CE + BW + MCE + WW + YW + Marb + YG + BF + REA + Stay + Milk + MWW + CW + Doc + ADG, data = simpledf, na.action=na.omit)
apiSimplePrediction <- lm(API~ CE + BW + WW + YW + Marb + YG + BF + Stay + ADG, data = simpledf, na.action=na.omit)
tiFullPrediction <- lm(TI~ CE + BW + MCE + WW + YW + Marb + YG + BF + REA + SHR + Stay + Milk + MWW + CW + Doc + ADG, data = simpledf, na.action=na.omit)
tiSimplePrediction <- lm(TI~ BW + WW + Marb, data = simpledf, na.action=na.omit)

#print('full api')
#print(summary(apiFullPrediction))
print('full api (no shr)')
print(summary(apiFullPredictionNoShr))
#print('simple api')
#print(summary(apiSimplePrediction))
#print('full ti')
#print(summary(tiFullPrediction))
#print('simple ti')
#print(summary(tiSimplePrediction))

apiFPCoef <- summary(apiFullPrediction)$coefficients
apiFPNoShrCoef <- summary(apiFullPredictionNoShr)$coefficients
apiSPCoef <- summary(apiSimplePrediction)$coefficients
tiFPCoef <- summary(tiFullPrediction)$coefficients
tiSPCoef <- summary(tiSimplePrediction)$coefficients

simpledf$calculatedFPAPI <- apiFPCoef[1] + (apiFPCoef[2]*simpledf$CE) + (apiFPCoef[3]*simpledf$BW) + (apiFPCoef[4]*simpledf$MCE) + (apiFPCoef[5]*simpledf$WW) + (apiFPCoef[6]*simpledf$YW) + (apiFPCoef[7]*simpledf$Marb) + (apiFPCoef[8]*simpledf$YG) + (apiFPCoef[9]*simpledf$BF) + (apiFPCoef[10]*simpledf$REA) + (apiFPCoef[11]*simpledf$SHR) + (apiFPCoef[12]*simpledf$Stay) + (apiFPCoef[13]*simpledf$Milk) + (apiFPCoef[14]*simpledf$MWW) + (apiFPCoef[15]*simpledf$CW) + (apiFPCoef[16]*simpledf$Doc) + (apiFPCoef[17]*simpledf$ADG)
simpledf$calculatedFPAPINoShr <- apiFPNoShrCoef[1] + (apiFPNoShrCoef[2]*simpledf$CE) + (apiFPNoShrCoef[3]*simpledf$BW) + (apiFPNoShrCoef[4]*simpledf$MCE) + (apiFPNoShrCoef[5]*simpledf$WW) + (apiFPNoShrCoef[6]*simpledf$YW) + (apiFPNoShrCoef[7]*simpledf$Marb) + (apiFPNoShrCoef[8]*simpledf$YG) + (apiFPNoShrCoef[9]*simpledf$BF) + (apiFPNoShrCoef[10]*simpledf$REA) + (apiFPNoShrCoef[11]*simpledf$Stay) + (apiFPNoShrCoef[12]*simpledf$Milk) + (apiFPNoShrCoef[13]*simpledf$MWW) + (apiFPNoShrCoef[14]*simpledf$CW) + (apiFPNoShrCoef[15]*simpledf$Doc) + (apiFPNoShrCoef[16]*simpledf$ADG)
simpledf$calculatedSPAPI <- apiSPCoef[1] + (apiSPCoef[2]*simpledf$CE) + (apiSPCoef[3]*simpledf$Marb) + (apiSPCoef[4]*simpledf$Stay)+ (apiSPCoef[5]*simpledf$SHR)


#plot <- ggplot(simpledf, aes(x=calculatedFPAPINoShr, y=API))
plot <- ggplot(simpledf, aes(x=calculatedFPAPI, y=API))
#plot <- ggplot(simpledf, aes(x=calculatedSPAPI, y=API))
plot <- plot + geom_point(color='blue')
plot <- plot + theme_classic()
plot <- plot + ggtitle("API Prediction (No SHR) vs. Actual")
plot <- plot + xlab("API Prediction")
print(plot)


