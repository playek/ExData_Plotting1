

# loadDataSet function to load the required data and return a dataframe containing relevent dataset.
# It takes two file names as argument, first one is the name of file that holds the extrenal data downloaded 
# from public url. Second one is the name of file that holds the subset of the data required for plotting.
# It does the followings 
# If plotDataFile exists - read it and return the dataframe
# if plotDataFile does not exists but zipDataFile exists , first prepare the plotDataFile and read it.
# if none of the files exists, it first download the file , then prepare the plotDataFile and finally reads it.

loadDataSet<- function (zipDataFile, plotDataFile)
{
  if(!file.exists(plotDataFile) )
  {
    if( !file.exists(zipDataFile))
    {
      print( "downloading the data ....")
      download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",zipDataFile)
    }
    
    print( "preparing  the subset data ....")
    unZipFile = unzip ( zipDataFile)
    
    data <- read.table(unZipFile, header=T, na.strings = "?", sep=";", stringsAsFactors=F)
    
    data <- data[(data$Date == "1/2/2007") | (data$Date == "2/2/2007"),]
    write.csv(data, plotableDataFile, row.names =F)
    
    file.remove(unZipFile)
    data
  }else
  {
    print( "reading  the subset data ....")
    
    data <- read.csv(plotDataFile, stringsAsFactors=F)
    data
  }
  
}

#function to plot  Global_active_power ~ DateNTime
plotIt <- function ( plotableData, imageFile="plot4.png")
{
  print ( "ploting  ....")
  
  plotableData$DateTime <- strptime(paste(plotableData$Date, plotableData$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
  
  png(filename=imageFile, width=480, height=480)
  
  par(mfcol=c(2,2))
  plot(plotableData$DateTime,  plotableData$Global_active_power, 
       type="l",
       col="black", 
       xlab="",  ylab="Global Active Power (kilowatts)", 
       main="")
  
  plot(plotableData$DateTime,  plotableData$Sub_metering_1, 
       type="l",
       col="black", 
       xlab="",  ylab="Energy sub metering", 
       main="")
  lines(plotableData$DateTime, plotableData$Sub_metering_2, col="red")
  lines(plotableData$DateTime, plotableData$Sub_metering_3, col="blue")
  legend("topright", 
         lwd=1, lty=2, 
         col = c("black", "red", "blue"), 
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  
  plot(plotableData$DateTime,  plotableData$Voltage, 
       type="l",
       col="black", 
       xlab="datetime", ylab="Voltage", 
       main="")
  
  plot(plotableData$DateTime, plotableData$Global_reactive_power, 
       type="l",
       col="black", 
       xlab="datetime", ylab="Global_reactive_power", 
       main="")
  
  
  dev.off()
  print ( "ploting Done.")
}

# main code that invoke the functions to load the data and plot it 

#setwd("E:\\documents\\Coursera\\Data Science\\Exploratory_data_analysis\\assignments\\CourseProject1")

localZippedDataFile <- "exdata-data-household_power_consumption.zip"
plotableDataFile <- "plotable_data-household_power_consumption.csv"

data <- loadDataSet(localZippedDataFile, plotableDataFile)


plotIt(data)