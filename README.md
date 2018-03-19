# convert_Pisces_Albatross
Apply Bigelow to Albatross calibration factors to 2017 fall bottom trawl survey conducted on Pisces for use in SAGA

# How to run
Conduct your usual SAGA analysis applying Bigelow to Albatross calibration factors. Because the 2017 fall bottom trawl survey was conducted on the Pisces instead of the Bigelow, the calibrations will not be applied for this survey. This R code modifies the SAGA generated MergedCatch_XXX.txt file (where XXX is the species code, e.g. 105 for yellowtail flounder) using the StationView_XXX.txt and CONV_APPLIED.TXT files created by SAGA. This code assumes the Weight Option "Specifiy Weight Calibration Factor" was selected in the Bigelow Calibration tab of SAGA (meaning a single value is applies to the catch weight). All you need to do is change the directory where the files are located (my.wd <- "enter_your_directory_here_with_double_forward_slash_at_end") and the species code for the station and catch files (change 105 to your species code). Running the R code will produce a file called MergedCatch_convertedP2A.txt that should be used in place of the original merged catch file when running Survan.

# Notes
This code relies on SAGA conducting all the checks to ensure that no holes appear in the data, for example a length without a calibration. Multiple years can be run, only the 2017 fall survey will have data modified, so a continuous time series output can be created. 
