#
# plot4.R creates 4 plots as follows:
#
# Top Left      Global Active Power over 2 days
# Top Right     Voltage over 2 days
# Bottom Right  Global Reactive Power over 2 days
# Bottom Left   Energy Sub-metering (kitchen, laundry, and water heater) over 2 days
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

# Create 4 plots and label y-axis and x-axis for each as per project instructions.
# Write directly to PNG file, the default is already 480x480 so no  need to explicitly specify. 
# Close the PNG file device. The plot is placed in "figure" directory.

png(file="figure/plot4.png")
par(mfrow=c(2,2))

# Create the 1st plot in top left corner
with(df, {plot(df$DateTime, V3, type="l",xlab="", ylab="Global Active Power (kilowatt)")})

# Create the 2nd plot in top right corner
with(df, {plot(df$DateTime, V5, type="l",xlab="datetime", ylab="Voltage")})

# Create the 3rd plot in bottom left corner (use bty=n to remove the box around legend)
with (df, {plot(df$DateTime, V7, type="l", col="Black", xlab="", ylab="Energy sub metering")})
with (df, {points(df$DateTime, V8, type="l", col="Red")})
with (df, {points(df$DateTime, V9, type="l", col="Blue")})
legend("topright", lty=1, bty="n", cex = 0.96, col=c("Black", "Blue", "Red"), 
       legend=c("Sub_metering1", "Sub_metering2","Sub_metering3"))

# Create the 4th plot in bottom right corner
with (df, {plot(df$DateTime, V4, type="l",xlab="datetime", ylab="Global_reactive_power")})
dev.off()

# End plot4