# convert_Pisces_Albatross.r
# apply Bigelow to Albatross calibration factors to 2017 fall bottom trawl survey conducted on Pisces
# assumes SAGA has been run to attempt (and fail) to apply calibrations already
# created 19 March 2018  Chris Legault

# set directory where files are located and which files to use
my.wd <- "C:\\Users\\chris.legault\\Desktop\\convertP2A\\"
station.file <- "StationView_105.txt"
mergedcatch.file <- "MergedCatch_105.txt"
convapplied.file <- "CONV_APPLIED.TXT"

# do not have to change anything below here---------------------------------------

# read SAGA data
station.dat <- read.table(paste0(my.wd, station.file), header=TRUE)
mergedcatch.dat <- read.table(paste0(my.wd, mergedcatch.file), header=TRUE, colClasses = c("numeric", rep("character",4), rep("integer",2), rep("numeric", 2), "integer", "numeric"))

# extract calibration data 
convapplied <- readLines(paste0(my.wd, convapplied.file))
nlines <- length(convapplied)
lines <- 1:nlines
skiplines <- lines[convapplied == "LENGTH         FACTORS"]
endlines <- lines[substr(convapplied, 1, 24) == "CONSTANT WEIGHT FACTOR =" ]
len.cal.dat <- read.table(paste0(my.wd, convapplied.file), skip=skiplines-1, header=TRUE, nrows=endlines-skiplines-1)
wt.cal.dat <- as.numeric(substr(convapplied[endlines], 25, 999))

# check station data to make sure Pisces (PC) used in fall 2017 survey (201704)
vessel.check <- FALSE
s2017 <- station.dat[station.dat$Cruise == 201704,]
if (length(unique(s2017$SV)) >= 2 | s2017$SV[1] != "PC"){
  print("Error, something wrong in station data")
}else{
  print("OK to continue")
  vessel.check <- TRUE
}

# convert the merged catch data
if(vessel.check){
   convertedcatch <- mergedcatch.dat
   for (i in 1:length(convertedcatch[,1])){
     if(convertedcatch$Cruise[i] == 201704){
       catchwtin <- convertedcatch$CATCHWT[i]
       catchwtout <- catchwtin / wt.cal.dat
       convertedcatch$CATCHWT[i] <- catchwtout
       numlenin <- convertedcatch$NUMLEN[i]
       numlenout <- numlenin / len.cal.dat$FACTORS[len.cal.dat$LENGTH == convertedcatch$LENGTH[i]]
       convertedcatch$NUMLEN[i] <- numlenout
     } 
   }
   # sum converted catch by station for NUMLEN
   for (i in 1:length(convertedcatch[,1])){
     if(convertedcatch$Cruise[i] == 201704){
       station.catch <- convertedcatch[convertedcatch$Station == convertedcatch$Station[i], ]
       convertedcatch$CATCHNUM[i] <- sum(station.catch$NUMLEN)
     }
   }
   # make new merged catch input file for SAGA
   write.table(convertedcatch, 
               file=paste0(my.wd, "MergedCatch_convertedP2A.txt"), 
               quote=FALSE, row.names=FALSE, sep="  ")
}

