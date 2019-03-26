library(ggplot2)
setwd('~/Desktop/Githubs/breeding-app-1/breeding-app-backend')
print(getwd())

df <- read.csv(file="animals2.csv")

df$BirthYear <- with(df, format(as.Date(BirthDate, format="%Y-%m-%d"), "%Y"))

print('Calving Ease EPD')
print(mean(subset(df, BirthYear=="2005")$Epds.CeEpd, na.rm=TRUE))
print(mean(subset(df, BirthYear=="2006")$Epds.CeEpd, na.rm=TRUE))
print(mean(subset(df, BirthYear=="2007")$Epds.CeEpd, na.rm=TRUE))
print(mean(subset(df, BirthYear=="2008")$Epds.CeEpd, na.rm=TRUE))
print(mean(subset(df, BirthYear=="2009")$Epds.CeEpd, na.rm=TRUE))
print(mean(subset(df, BirthYear=="2010")$Epds.CeEpd, na.rm=TRUE))

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
plot <- plot + ggtitle("API Actual")

print(plot)

print(cor(simpledf$API, simpledf$APIPredictor, use="complete.obs", method="pearson"))

