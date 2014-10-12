

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

#function to plot the histogram. 
plotIt <- function ( plotableData, imageFile="plot1.png")
{
  print ( "ploting histogram ....")
  png(filename=imageFile, width=480, height=480)
  hist(plotableData$Global_active_power, col="red", 
       xlab="Global Active Power (kilowatts)", 
       main="Global Active Power")
  dev.off()
  print ( "ploting Done.")
}

# main code that invoke the functions to load the data and plot it 

#setwd("E:\\documents\\Coursera\\Data Science\\Exploratory_data_analysis\\assignments\\CourseProject1")

localZippedDataFile <- "exdata-data-household_power_consumption.zip"
plotableDataFile <- "plotable_data-household_power_consumption.csv"

data <- loadDataSet(localZippedDataFile, plotableDataFile)
plotIt(data)