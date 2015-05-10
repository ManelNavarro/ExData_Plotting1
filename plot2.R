##plot2.R
##Global Active Power (time evolution)

##Assumption: base data file is in working folder, already unzipped ("household_power_consumption.txt")
##Base data file NOT pushed to github as it is large (120Mb uncompressed) and it is already available on website
##
##To save memory use and speed up data load, an initial analysis of the file has been performed
##using read.table with "nrows" and "skip" arguments and "head" / "tail" on the result, concluding that:
##1) starting date is 16/12/20007
##2) each day takes approximately 1450 rows
##
##Therefore, data will be loaded only for 6000 rows after skipping initial 65k rows 
##(i.e. skipping approximately last 15 days of December and 30 days of January and taking enough rows
##to ensure that first 2 days of February 2007 are included entirely)

##Load packages
library(stringr)

##STEP 1) LOAD DATA

##Define colclasses to speed up data load
readclass<-c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

##Load data for the selected rows, keeping original headers and defining "?" as NA as per instructions
datanames<-colnames(read.table("household_power_consumption.txt",header=TRUE,nrows=1,sep=";"))
hdata<-read.table("household_power_consumption.txt",
                  col.names=datanames,                            #original column names
                  header=TRUE,skip=65000,nrows=6000,              #approx rows required
                  sep=";",colClasses=readclass,na.strings="?")    #separator, classes and NA string

#Tranform dates, times
hdata$DateTime<-strptime(paste0(hdata$Date,hdata$Time),"%d/%m/%Y%H:%M:%S")      #Creates new POSIXlt variable

#Select only required timeframe
hdata<-hdata[(hdata$DateTime>=strptime("1/2/2007","%d/%m/%Y") & hdata$DateTime<strptime("3/2/2007","%d/%m/%Y")),]

##STEP 2) PLOT DATA

##Set Locale time variable to english to replicate exactly required plot
##(otherways weekdays are plotted in local language)
LCT<-Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")

#Initialize device
png("plot2.png")                                                #default resolution is 480x480 as required

#Plot with annotations
with(hdata,
     plot(DateTime, Global_active_power,
          type="l",
          xlab="",
          ylab="Global Active Power (kilowatts)")
)
#Close device
dev.off()

##Recover locale time variable
Sys.setlocale("LC_TIME",LCT)
