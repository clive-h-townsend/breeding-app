library(ggplot2)
library(extrafont)

# Select the working directory. This is where images will be placed. 
# - - - Linux Option
setwd('/home/clive/Desktop/GHS/breeding-app-1/breeding-app-backend/Data/OutputDump/')
# - - - Mac Option
#setwd('~/Desktop/Githubs/breeding-app/breeding-app-backend/SourceData/')

# Show the correctly set working directory
print(getwd())

# Read in the clean data file
df <- read.csv(file="../SourceData/CleanData.csv")
# Read in the ASA Hybrid statistics
df.asatable <- read.table(file='../ASAData/Hybrid.txt', header=TRUE)

# Format the birth year from the birth date
df$BirthYear <- with(df, format(as.Date(BirthDate, format="%Y-%m-%d"), "%Y"))

# A list of the available years
years = c( "2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016")

# A List of the EPDs to plot
epds <- c("Epds.BirthWtEpd", "Epds.YearlingWtEpd", "Epds.CeEpd", "Epds.WeanWtEpd", "Epds.Api", "Epds.Ti", "Epds.BackFatEpd")
# The EPDs Full Common Name
epdNames <- c("Birth Weight", "Yearling Weight" , "Calving Ease", "Wean Weight", "API", "TI", "Back Fat")

# Fore every epd, plot its trend over time for given birth years
i <- 1
for (epd in epds) {
  
  # Vector to hold the trend data
  epdTrend <- c()
  for (year in years) {
    # Find the mean of the data for a given birth year
    epdYearAvg <- mean(subset(df, BirthYear==year)[[epd]], na.rm=TRUE)
    # Add that value to the trend
    epdTrend <- c(epdTrend, epdYearAvg)
  } 
  # Print the name of the epd and how it is trending
  print(epdNames[i])
  print(epdTrend)
  # Put the data into a data frame
  dfepds <- data.frame(years, epdTrend)
  
  # Plot the EPD trend over time
  plot <- ggplot(dfepds, aes(years, epdTrend))
  plot <- plot + geom_point(color='blue', size=5, shape=21, fill="white", stroke=5) #+ stat_smooth(method="lm", col="red")
  plot <- plot + theme_classic()
  plot <- plot + ggtitle(paste("Year vs. ",epdNames[i]))
  plot <- plot + xlab("Year")
  plot <- plot + ylab(epdNames[i])
  
  # Print the plot to a .png file
  png(paste("Year vs. ", epdNames[i], ".png"))
  print(plot)
  
  # Turn off the printer (?)
  dev.off()
  
  i <- i + 1
}

# This data frame holds the name of the differing EPDs to analyze for the herd vs the ASA dataset
simpledf <- data.frame(
  "CE" = df$Epds.CeEpd, 
  "BW" = df$Epds.BirthWtEpd,
  "MCE" = df$Epds.MceEpd,
  "WW" = df$Epds.WeanWtEpd,
  "YW" = df$Epds.YearlingWtEpd,
  "MRB" = df$Epds.MarblingEpd,
  "YG" = df$Epds.YieldGradeEpd,
  "BF" = df$Epds.BackFatEpd,
  "REA" = df$Epds.RibEyeEpd,
  "SF" = df$Epds.ShrForceEpd,
  "STY" = df$Epds.StayEpd,
  "MLK" = df$Epds.MilkEpd,
  "MWW" = df$Epds.MwwEpd,
  "CWT" = df$Epds.CarcassWtEpd,
  "DOC" = df$Epds.DocEpd,
  "PWG" = df$Epds.AdgEpd,
  "API" = df$Epds.Api,
  "TI" = df$Epds.Ti, 
  "YEAR" = df$BirthYear
)

simpleaccdf <- data.frame(
  "CE" = df$Epds.CeAcc, 
  "BW" = df$Epds.BirthWtAcc,
  "MCE" = df$Epds.MceAcc,
  "WW" = df$Epds.WeanWtAcc,
  "YW" = df$Epds.YearlingWtAcc,
  "MRB" = df$Epds.MarblingAcc,
  "YG" = df$Epds.YieldGradeAcc,
  "BF" = df$Epds.BackFatAcc,
  "REA" = df$Epds.RibEyeAcc,
  "SF" = df$Epds.ShrForceAcc,
  "STY" = df$Epds.StayAcc,
  "MLK" = df$Epds.MilkAcc,
  "MWW" = df$Epds.MwwAcc,
  "CWT" = df$Epds.CarcassWtAcc,
  "DOC" = df$Epds.DocAcc,
  "PWG" = df$Epds.AdgAcc,
  "YEAR" = df$BirthYear
)

print('The column names:')
print(colnames(simpledf))

selectedYear <- "2016"

# Select the herd year to analyze
simpledf <- simpledf[which(simpledf$YEAR==selectedYear),]
simpleaccdf <- simpleaccdf[which(simpleaccdf$YEAR==selectedYear),]

epdSimpleName <- colnames(simpledf)
#               "CE" "BW" "MCE"  "WW"   "YW"   "Marb"  "YG"   "BF"   "REA"  "SHR"  "Stay" "Milk" "MWW"  "CW"   "Doc"  "ADG"  "API"  "TI" 
epdBinWidth <- c(0.5, 0.5, 1,     3,     5,     0.1,   0.05,  0.01,     0.1, 0.05,     1,     1,    1,  5,     1,  0.01,     2,   5)

i <- 1
for (epdName in epdSimpleName) {
  
  
  if (!(epdName == 'API' || epdName == 'TI' || epdName == 'YEAR')) {
    
    # Show some high level information regarding the EPD
    # Get the mean for the herd
    epdMean <- mean(simpledf[[epdName]], na.rm=TRUE)
    epdAcc <- mean(simpleaccdf[[epdName]], na.rm=TRUE)
    epdAcc <- epdMean * epdAcc
    # Show the industry mean
    epdASAMean <- df.asatable[[epdName]][14]
    epdASATop20P <- df.asatable[[epdName]][8]
    epdASATop5P <- df.asatable[[epdName]][5]
    print(paste(epdName,'  Herd Mean:', epdMean,'+/-', epdAcc, '   ASA Mean:', epdASAMean, sep=" "))
    
    # Subtitle Holder
    mysubTitle <- ''
    
    
    # Better to be high
    if (epdASATop5P > epdASATop20P) {
      if (epdMean - epdAcc > epdASAMean) {
        mysubTitle <- 'Outperformer'
        print(paste('Performing well in ', epdName))
      }
      if (epdMean + epdAcc < epdASAMean) {
        mysubTitle <- 'Underperformer'
        print(paste('Not performing well in ', epdName))
      }
    }
    # Better to be low
    if (epdASATop5P < epdASATop20P) {
      if (epdMean + epdAcc < epdASAMean) {
        mysubTitle <- 'Outperformer'
        print(paste('Performing well in ', epdName))
      }
      if (epdMean - epdAcc > epdASAMean) {
        mysubTitle <- 'Underperformer'
        print(paste('Not performing well in ', epdName))
      }
      
    }
    # Create a plot of the data for the relevant EPD
    plot <- ggplot(simpledf, aes(x=!!rlang::sym(epdName)))
    plot <- plot + geom_histogram(binwidth=epdBinWidth[i], fill='black')
    plot <- plot + geom_vline(aes(xintercept=epdMean, color="Herd Mean"), linetype="solid", size=2)
    plot <- plot + geom_vline(aes(xintercept=(epdMean+epdAcc), color='Confidence Bounds'), linetype="dashed", size=0.5)
    plot <- plot + geom_vline(aes(xintercept=(epdMean-epdAcc), color='Confidence Bounds'), linetype="dashed", size=0.5)
    plot <- plot + geom_vline(aes(xintercept=epdASAMean, color="ASA Mean"), linetype="solid", size=2) 
    plot <- plot + geom_vline(aes(xintercept=epdASATop20P, color="ASA Top 20%"), linetype="solid", size=2) 
    plot <- plot + scale_color_manual(name = "Herd vs ASA Data", values = c("ASA Top 20%"='green' ,'Herd Mean' = "blue", 'ASA Mean' = "red", 'Confidence Bounds'='lightblue', 'Confidence Bounds'='lightblue'))
    
    
    plot <- plot + theme_classic()
    plot <- plot + ggtitle(paste(epdName," vs. ",'%'), subtitle = mysubTitle)
    plot <- plot + xlab(epdName)
    plot <- plot + theme(
      axis.text=element_text(size=20), 
      axis.title=element_text(size=25, face='bold'), 
      text=element_text(size=16, family="serif"),
      plot.title=element_text(size=30, face='bold', hjust=0.5),
      plot.subtitle = element_text(size=20, hjust=0.5)
    )
    plot <- plot + ylab('%')
    
    png(paste(epdName, " vs. Frequency.png"))
    print(plot)
    dev.off()
  } 
  if (epdName == 'API' || epdName == 'TI') {
    # Show some high level information regarding the EPD
    # Get the mean for the herd
    epdMean <- mean(simpledf[[epdName]], na.rm=TRUE)
    # Show the industry mean
    epdASAMean <- df.asatable[[epdName]][14]
    epdASATop20P <- df.asatable[[epdName]][8]
    epdASATop5P <- df.asatable[[epdName]][5]
    print(paste(epdName,'  Herd Mean:', epdMean, '   ASA Mean:', epdASAMean, sep=" "))
    
    
    # Subtitle Holder
    mysubTitle <- ''
    
    # Better to be high
    if (epdMean > epdASAMean) {
      print(paste('Performing well in ', epdName))
      mysubTitle <- 'Outperformer'
    }
    if (epdMean < epdASAMean) {
      print(paste('Underperforming in ', epdName))
      mysubTitle <- 'Underperformer'
    }

    
    # Create a plot of the data for the relevant EPD
    plot <- ggplot(simpledf, aes(x=!!rlang::sym(epdName)))
    plot <- plot + geom_histogram(binwidth=epdBinWidth[i], fill='black')
    plot <- plot + geom_vline(aes(xintercept=epdMean, color="Herd Mean"), linetype="solid", size=2)
    plot <- plot + geom_vline(aes(xintercept=epdASAMean, color="ASA Mean"), linetype="solid", size=2) 
    plot <- plot + geom_vline(aes(xintercept=epdASATop20P, color="ASA Top 20%"), linetype="solid", size=2) 
    plot <- plot + scale_color_manual(name = "Herd vs ASA Data", values = c("ASA Top 20%"='green' ,'Herd Mean' = "blue", 'ASA Mean' = "red", '-Conf'='lightblue', '+Conf'='lightblue'))
    
    
    plot <- plot + theme_classic()
    plot <- plot + ggtitle(paste(epdName," vs. ",'%'), subtitle = mysubTitle)
    plot <- plot + xlab(epdName)
    plot <- plot + theme(
      axis.text=element_text(size=20), 
      axis.title=element_text(size=25, face='bold'), 
      text=element_text(size=16, family="serif"),
      plot.title=element_text(size=30, face='bold', hjust=0.5),
      plot.subtitle = element_text(size=20, hjust=0.5)
    )
    plot <- plot + ylab('%')
    
    png(paste(epdName, " vs. Frequency.png"))
    print(plot)
    dev.off()
  }
  
  i <- i + 1
}




