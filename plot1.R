#############################################
## 0. Check if the remote file has already
##    been cached to the local directory.
##    If not, then download it. If the data,
##    set isn't extracted yet, then unzip it.

	require(downloader)
	dataDir <- paste(getwd(),"\\data",sep="")					## Check if local data dir exists
	if (!file.exists(dataDir)) {
		message("Creating data folder...")					## Otherwise create it
	    	dir.create(dataDir)
	}
	fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
	zipFile <- paste(dataDir,"\\hpc.zip",sep="")
	if (!file.exists(zipFile)) {		   					## Check if local zip file exists
		message("Downloading raw data...")
    		download(fileUrl, zipFile, mode = "wb")				## Otherwise download it
		message(paste("Data downloaded on ",date(),sep=""))
	}
	txtFile <- paste(dataDir,"\\household_power_consumption.txt",sep="")
	if (!file.exists(txtFile)) {							## Check if the uncompressed file exists
		message("Extracting compressed data...")
		unzip(zipfile=zipFile,exdir = dataDir)				## Otherwise extract it
	}

###########################################
## 1. Read data from txt file and fix date
##    and time

	message("Reading data...")
	epc.df <- read.table(txtFile, 
				   header = TRUE,
                           sep = ";",
  				   na.strings = "?",
                           colClasses = c("character",
                                          "character",
                                          rep("numeric",7)
                                        )
                )
	epc.df$DateTime <- strptime(paste(epc.df$Date,epc.df$Time),
                                  "%d/%m/%Y%H:%M:%S")

##################################################
## 3. Subset accordingly to the desired timeframe,
##    removing NA's

	message("Subsetting...")
	used <- epc.df[epc.df$DateTime>=strptime("01/02/2007 00:00:00",
                                  "%d/%m/%Y%H:%M:%S") & 
                     epc.df$DateTime<strptime("03/02/2007 00:00:00",
                                  "%d/%m/%Y%H:%M:%S"),]
	used <- used[!is.na(used$Global_active_power),]
	
###############################################
## 4. Generate the required histogram, with the
##    appropriate labels, and save to the PNG
##    file

	message("Saving to PNG file...")
	png(file=paste(getwd(),"\\plot1.png",sep=""))
	hist(used$Global_active_power,
           main="Global Active Power",
           xlab="Global Active Power (kilowatts)",
           ylab="Frequency",
           col="red")
	dev.off()
	message("Done.")


	