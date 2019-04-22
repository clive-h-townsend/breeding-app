library(ggplot2)
library(extrafont)

# Select the working directory. This is where images will be placed. 
# - - - Linux Option
setwd('/home/clive/Desktop/GHS/breeding-app/breeding-app-backend/Data/OutputDump/')
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

# The EPDs Full Common Name
epdNames <- c("Birth Weight", "Yearling Weight" , "Calving Ease", "Wean Weight", "API", "TI", "Back Fat")



# This data frame holds the name of the differing EPDs to analyze for the herd vs the ASA dataset
simpledf <- data.frame(
  "CE" = df$Epds.CeEpd, 
  "BW" = df$Epds.BirthWtEpd,
  "MCE" = df$Epds.MceEpd,
  "WW" = df$Epds.WeanWtEpd,
  #"YW" = df$Epds.YearlingWtEpd,
  "MRB" = df$Epds.MarblingEpd,
  "YG" = df$Epds.YieldGradeEpd,
  #"BF" = df$Epds.BackFatEpd,
  #"REA" = df$Epds.RibEyeEpd,
  #"SF" = df$Epds.ShrForceEpd,
  "STY" = df$Epds.StayEpd,
  "MLK" = df$Epds.MilkEpd,
  "MWW" = df$Epds.MwwEpd,
  "CWT" = df$Epds.CarcassWtEpd,
  "DOC" = df$Epds.DocEpd,
  #"PWG" = df$Epds.AdgEpd,
  "API" = df$Epds.Api,
  "TI" = df$Epds.Ti, 
  "YEAR" = df$BirthYear
)




print('The column names:')
print(colnames(simpledf))

selectedYear <- "2016"

# Select the herd year to analyze
simpledf <- simpledf[which(simpledf$YEAR==selectedYear),]

epdSimpleName <- colnames(simpledf)

asaTop5Score <- 3
asaTop20Score <- 2
asaTop40Score <- 1
asaTop60Score <- 0

scoreList <- c()

i <- 1
for (animal in simpledf$CE) {
  
  score <- 0
  
  j <- 1
  while (j < length(epdSimpleName)) {
    

    # If the value is not NA
    if (!is.na(simpledf[[epdSimpleName[j]]][i])) {
      
      # If the epd value is greater than  5th percentile
      if (simpledf[[epdSimpleName[j]]][i] > df.asatable[[epdSimpleName[j]]][5]) {
        
        score <- score + asaTop5Score
        
      } else {
        
        if (simpledf[[epdSimpleName[j]]][i] > df.asatable[[epdSimpleName[j]]][8]) {
          
          score <- score + asaTop20Score
          
        } else {
          if (simpledf[[epdSimpleName[j]]][i] > df.asatable[[epdSimpleName[j]]][12]) {
            
            score <- score + asaTop40Score
            
          } else {
            if (simpledf[[epdSimpleName[j]]][i] > df.asatable[[epdSimpleName[j]]][16]) {
              
              score <- score + asaTop60Score
              
            }
          }
        }
        
        
      }
      
      
      
    }
    
    
    
    j <- j + 1
  }
  
  scoreList <- c(scoreList, score)
  
  i <- i + 1

   
}

simpledf['scores'] <- scoreList

simpledf <- simpledf[which(simpledf$scores > 0),]

meanScore <- mean(simpledf$scores)
sdScore <- sd(simpledf$scores)
cutLine <- meanScore - sdScore

# Create a plot of the data for the relevant EPD
plot <- ggplot(simpledf, aes(x=scores))
plot <- plot + geom_histogram(binwidth=1, fill='black')
plot <- plot + geom_vline(aes(xintercept=cutLine, color="Cut Line"), linetype="solid", size=2)
plot <- plot + geom_vline(aes(xintercept=meanScore, color='Herd Mean'), linetype="dashed", size=2)

plot <- plot + theme_classic()
plot <- plot + ggtitle('Score Distribution', subtitle = '2016')
plot <- plot + xlab('Scores')
plot <- plot + theme(
  axis.text=element_text(size=20), 
  axis.title=element_text(size=25, face='bold'), 
  text=element_text(size=16, family="serif"),
  plot.title=element_text(size=30, face='bold', hjust=0.5),
  plot.subtitle = element_text(size=20, hjust=0.5)
)
plot <- plot + ylab('%')
#plot <- plot + xlim(c(0, 40))

#png( "Score vs. Frequency.png")
print(plot)
#dev.off()
  

  
  
  
  
 # print(score)
  

