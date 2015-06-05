setwd("D:/WORK/MOOC-ExploratoryDataAnalysis")
#rmall <- function() rm(list=ls(envir=globalenv()), envir=globalenv()); rmall()

library(dplyr)

MEMOIZE <- TRUE
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "exdata data household_power_consumption.zip"
txtFile <- "household_power_consumption.txt"
rdataFile <- "household_power_consumption.RData"

## read txt file
if ((MEMOIZE && file.exists(rdataFile))) {
	load(file=rdataFile)
} else {
	## get zip file
	cat("downloading zip file...\n"); flush.console()
	setInternet2(use=TRUE)
	download.file(url=url, destfile=zipFile, mode="wb")
	unzip(zipFile, junkpaths=TRUE)

	## read txt file
	cat("reading txt file...\n"); flush.console()
	DF <- read.table(file=txtFile, header=TRUE, stringsAsFactors=FALSE, sep=";", na.strings="?"
		, colClasses=c(rep("character", 2), rep("numeric", 7))
	)

	## scope dataset to Feb 1, 2007 and Feb 2, 2007 only
	DF <- filter(DF, Date %in% c("1/2/2007", "2/2/2007"))

	## create POSIXct datetime column
	DF <- cbind(DF, datetime = strptime(paste(DF$Date, DF$Time), "%d/%m/%Y %H:%M:%S"))

	## save for subsequent runs
	cat("saving rdata file...\n"); flush.console()
	save(file=rdataFile, DF)
}
#head(DF)
#str(DF)

## plot1.R
## setup datetime column
png(filename = "plot1.png", width = 480, height = 480)
with(DF, hist(Global_active_power, col="red", main="Global Active Power"
	, xlab="Global Active Power (kilowatts)"))
dev.off()
