#
# plot1.R creates a histogram of Global Active Power
#
#
# Download the dataset and unzip the file if the household_power_consumption.txt does not already 
# exist in the current working directory. Skip this step otherwise.
#
#

fileurl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filename <- "household_power_consumption.txt"
if (!file.exists(filename)) 
{
  download.file(fileurl, destfile = "household_power_consumption.zip")
  unzip ("household_power_consumption.zip")
}

#
# Since there are over 2 million rows we dont want to read the whole file in R for performance
# reasons and it may be an issue on older computers dut o limited memory. The project asks for 
# measurements for couple of days in Feb 2007.
#
# Per README the observations are one per minute and each row represents a measurement, so we
# need to read just 2880 (2days* 24 hrs * 60 mins) lines. We will start at 1/2/2007 (00:00:00) 
# and finish at 2/2/2007 (23:59:00). Also the missing values are coded as "?".
#  

require(data.table)
df <- fread("household_power_consumption.txt", header=FALSE, 
             skip = "1/2/2007", nrow=2*24*60, na.strings=c("?",""))

# It has read 2880 rows and 9 (of 9) columns from 0.124 GB file in 00:00:06

# Paste the date and time columns together before converting into date/time format
df$V2 <- paste(df$V1, df$V2, sep = " ")
temp <- data.frame("Date.Time" = df$V2)
temp$Date.Time <- strptime(temp$Date.Time, format = "%d/%m/%Y %H:%M:%S")

# Add a new column "DateTime" to the table
df$DateTime <- as.POSIXct(temp$Date.Time)
rm(temp)

# Create a histogram and write directly to PNG file, note the default is 480x480 so no need to
# explicitly specify. The plots are placed in "figure" directory. Close the PNG file device

png(file="figure/plot1.png")
hist(df$V3, col="Red", 
     main="Global Active Power", xlab="Global Active Power (kilowatt)", ylab="Frequency")
dev.off()

# End plot1