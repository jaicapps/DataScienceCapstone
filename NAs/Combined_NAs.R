df=read.csv("pluto_18v2_1.csv")
source("NAs/utils.R")
colnames(df)
str(df)

#######################################################################################################################################
# borough
class(df$borough)
summary(df$borough)
table(is.na(df$borough))
# Delete levels that are extremely large (errors):
df$borough <- as.factor(df$borough)
l <- levels(df$borough)
# Check amount of rows that have these rare (erronous values) boroughs:
dim(df[df$borough==l[1],])
dim(df[df$borough==l[2],])
dim(df[df$borough==l[3],])
dim(df[df$borough==l[4],])
dim(df[df$borough==l[5],])
dim(df[df$borough==l[6],])
# Remove rows within first 6 levels for borough (considered as rare):
dim(df)
df <- df[!(df$borough==l[1]), ]
df <- df[!(df$borough==l[2]), ]
df <- df[!(df$borough==l[3]), ]
df <- df[!(df$borough==l[4]), ]
df <- df[!(df$borough==l[5]), ]
df <- df[!(df$borough==l[6]), ]
dim(df)
df <- droplevels(df)
levels(df$borough)
#######################################################################################################################################

# zipcode
class(df$zipcode) 
levels(as.factor(df$zipcode)) # 212 levels. SHOULD IT BE CONVERTED TO FACTOR?!
table(is.na(df$zipcode))
# Rows containing zipcode as NA transfered into Python and repaired there.
# Saving these rows in the CSV file Zips_code in the folder zipcode_fill:
subset(df, is.na(zipcode)) %>% write.csv(., "zipcode_fill/Zips_code.csv")

# Deleting rows with NAs in zipcode from the data fram df:
df <- filter(df, !is.na(df$zipcode))

# Read the repaired CSV file which was created through the Python program:
fixed_zips <- read.csv('zipcode_fill/zips_fixed.csv')

# Row bind the old data frame (df) with the corrected zipcodes obtained through Python:
df <- rbind(df, fixed_zips)
summary(df$zipcode)
summary(df$borough)

df$zipcode <- as.factor(df$zipcode)
#######################################################################################################################################



# block
class(df$block) # Integer and kept as such since it would have 13977 levels as a factor
table(is.na(df$block)) # No NAs
df$block <- as.factor(df$block)
#######################################################################################################################################

# lot
class(df$lot) # Integer and kept as such since it would have 2545  levels as a factor
table(is.na(df$lot)) # No NAs
df$lot <- as.factor(df$lot)
#######################################################################################################################################

# cd
class(df$cd)
table(is.na(df$cd))
# Replace 994 NAs with random cd values of the corresponding boroughs:
df$cd[is.na(df$cd)] <- fill_NAs_by_zipcode(df,"cd")
# Removing the first digit of cd since it refers to the borough code which is information present in another
# column and converting to factor:
df$cd <- as.factor(substring(as.character(df$cd),2))
levels(df$cd) # 30 levels
#######################################################################################################################################

# ct2010 and cb2010 are deleted since we only use zipcode to match to census data.
# schooldist
class(df$schooldist)
table(is.na(df$schooldist))
# Replace 1632 NAs with random schooldist values of the corresponding boroughs and converting to factor:
df$schooldist[is.na(df$schooldist)] <- fill_NAs_by_zipcode(df,"schooldist")
df$schooldist <- as.factor(df$schooldist)
levels(df$schooldist) # 32 levels
#######################################################################################################################################

# council
class(df$council)
table(is.na(df$council))
# Replace 994 NAs with random council values of the corresponding boroughs and converting to factor:
df$council[is.na(df$council)] <- (fill_NAs_by_zipcode(df,"council"))
df$council <- as.factor(df$council)
levels(df$council) # 51 levels
#######################################################################################################################################

# firecomp
class(df$firecomp)
table(is.na(df$firecomp)) # No NAs
levels(df$firecomp) # 349 levels
#######################################################################################################################################

# policeprct
class(df$policeprct)
table(is.na(df$policeprct))
# Replace NAs with random policeprct values of the corresponding boroughs and converting to factor:
df$policeprct[is.na(df$policeprct)] <- fill_NAs_by_zipcode(df,"policeprct")
df$policeprct <- as.factor(df$policeprct)
levels(df$policeprct) # 76 levels
#######################################################################################################################################

# healtharea
class(df$healtharea)
table(is.na(df$healtharea))
# Replace NAs with random healtharea values of the corresponding boroughs and converting to factor:
df$healtharea[is.na(df$healtharea)] <- fill_NAs_by_zipcode(df,"healtharea")
df$healtharea <- as.factor(df$healtharea)
levels(df$healtharea) # 210 levels
#######################################################################################################################################

# sanitboro
class(df$sanitboro)
table(is.na(df$sanitboro))
# Replace NAs with random sanitboro values of the corresponding boroughs and converting to factor:
df$sanitboro[is.na(df$sanitboro)] <- fill_NAs_by_zipcode(df,"sanitboro")
df$sanitboro <- as.factor(df$sanitboro)
levels(df$sanitboro)
#######################################################################################################################################

# sanitsub
table(is.na(df$sanitsub)) # No NAs
# Converting to factor:
df$sanitsub <- as.factor(df$sanitsub)
levels(df$sanitsub)
#######################################################################################################################################

# address is deleted since it is textual and not required for the predictions.
# zonedist1
class(df$zonedist1)
table(is.na(df$zonedist1)) # No NAs
levels(df$zonedist1)
#######################################################################################################################################

# zonedist2, zonedist3, zonedist4, overlay1, and overlay2 are deleted since they provide too 
# much unnecessary detail and contain a vast majority of NAs or blanks.
# spdist1
class(df$spdist1)
table(df$spdist1=="")
# Replacing blanks with 0s and non-blank values with 1 and converting to factor:
df$spdist1 <- as.factor(ifelse(df$spdist1=="", 0, 1))
levels(df$spdist1)
#######################################################################################################################################

# spdist2 and spdist3 are deleted since they have a vast majority of blanks.
# ltdheight
class(df$ltdheight)
table(df$ltdheight=="")
# Replacing blanks with 0s and non-blank values with 1 and converting to factor:
df$ltdheight <- as.factor(ifelse(df$ltdheight=="", 0, 1))
levels(df$ltdheight)
#######################################################################################################################################

# splitzone deleted since assumed buildings are only in 1 zone, and actually very few buildings are in multiple zones.
# bldgclass deleted since this information is present in the landuse variable.
# landuse
class(df$landuse)
summary(as.factor(df$landuse))
# Replace NAs with 0s for unknown category:
df$landuse[is.na(df$landuse)] <- "0"
# Convert to factor:
df$landuse <- as.factor(df$landuse)
levels(df$landuse)
#######################################################################################################################################

# easements:
class(df$easements)
summary(as.factor(df$easements))
# Deleted since 854467 zeroes.
#######################################################################################################################################

# ownertype:
class(df$ownertype)
summary(df$ownertype)
# Deleted since 824226 blanks.
#######################################################################################################################################

# Delete the above chosen columns to be deleted:
df <- df[, !(colnames(df) %in% c('address','zonedist2','zonedist3','zonedist4', 'overlay1', 'overlay2', 'spdist2', 'spdist3', 'splitzone', 'bldgclass', 'easements', 'ownertype', 'ownername', 'ct2010', 'cb2010'))]
#######################################################################################################################################

# lotarea
class(df$lotarea)
table(df$lotarea==0)
summary(df$lotarea)
# Changing zeroes to NAs:
df$lotarea[df$lotarea==0] <- NA
# Replace NAs with median according to borough:
df$lotarea[is.na(df$lotarea)] <- fill_NAs_median(df, "lotarea")
#######################################################################################################################################

# bldgarea
class(df$bldgarea)
table(df$bldgarea==0)
summary(df$bldgarea)
# Removing NAs by changing NAs to 5s and then filtering these out:
df$bldgarea[is.na(df$bldgarea)] <- 5
df <- filter(df, bldgarea !=5)
# Bldgarea=0 considered for predicting assessed land value and not for assessed total value.
#######################################################################################################################################

# comarea
class(df$comarea)
table(df$comarea==0)
summary(df$comarea)
# Removing this column since it has a vast majority of 0s and NAs:
df <- subset(df, select = -c(comarea))
#######################################################################################################################################

# resarea
class(df$resarea)
table(df$resarea==0)
summary(df$resarea)
# Changing zeroes to NAs:
df$resarea[df$resarea==0] <- NA
# Since a total of nearly 100,000 rows contain 0 or NA values and as these cannot be replaced with the medians for 
# each borough without biasing the prediction model, this variable is removed:
df <- subset(df, select = -c(resarea))
#######################################################################################################################################

# officearea
class(df$officearea)
table(df$officearea==0)
summary(df$officearea)
# Removing this column since it has a vast majority of 0s and NAs:
df <- subset(df, select = -c(officearea))
#######################################################################################################################################

# retailarea
class(df$retailarea)
table(df$retailarea==0)
summary(df$retailarea)
# Removing this column since it has a vast majority of 0s and NAs:
df <- subset(df, select = -c(retailarea))
#######################################################################################################################################

# garagearea
class(df$garagearea)
table(df$garagearea==0)
summary(df$garagearea)
# Removing this column since it has a vast majority of 0s and NAs:
df <- subset(df, select = -c(garagearea))
#######################################################################################################################################

# strgearea
class(df$strgearea)
table(df$strgearea==0)
summary(df$strgearea)
# Removing this column since it has a vast majority of 0s and NAs:
df <- subset(df, select = -c(strgearea))
#######################################################################################################################################

# factryarea
class(df$factryarea)
table(df$factryarea==0)
summary(df$factryarea)
# Removing this column since it has a vast majority of 0s and NAs:
df <- subset(df, select = -c(factryarea))
#######################################################################################################################################

# otherarea
table(df$otherarea==0)
summary(df$otherarea)
# Removing this coulumn since it has a vast majority of 0s and NAs:
df <- subset(df, select = -c(otherarea))
#######################################################################################################################################

# areasource
# Removing areasource since it provides details about the source from which building area measurements is obtained,
# and this is unecessary for our prediction:
df <- subset(df, select = -c(areasource))
#######################################################################################################################################

# numbldgs
class(df$numbldgs)
summary(df$numbldgs)
# Replacing NAs with medians for each corresponding borough:
df$numbldgs[is.na(df$numbldgs)] <- fill_NAs_median(df, "numbldgs")
#######################################################################################################################################

# numfloors
class(df$numfloors)
summary(df$numfloors)
# Replacing NAs with medians for each corresponding borough:
df$numfloors[is.na(df$numfloors)] <- fill_NAs_median(df, "numfloors")
#######################################################################################################################################

# unitsres
class(df$unitsres)
summary(df$unitsres)
# Replacing NAs with medians for each corresponding borough:
df$unitsres[is.na(df$unitsres)] <- fill_NAs_median(df, "unitsres")
#######################################################################################################################################

# unitstotal
class(df$unitstotal)
summary(df$unitstotal)
# Replacing NAs with medians for each corresponding borough:
df$unitstotal[is.na(df$unitstotal)] <- fill_NAs_median(df, "unitstotal")
#######################################################################################################################################

# lotfront
class(df$lotfront)
summary(df$lotfront)
# Replacing NAs with medians:
df$lotfront[is.na(df$lotfront)] <- fill_NAs_median(df, "lotfront")
#######################################################################################################################################

# lotdepth
class(df$lotdepth)
summary(df$lotdepth)
# Replacing NAs with median for each corresponding borough:
df$lotdepth[is.na(df$lotdepth)] <- fill_NAs_median(df, "lotdepth")
#######################################################################################################################################

# bldgfront
class(df$bldgfront)
summary(df$bldgfront)
# Replacing NAs with medians for each corresponding borough:
df$bldgfront[is.na(df$bldgfront)] <- fill_NAs_median(df, "bldgfront")
#######################################################################################################################################

# bldgdepth
class(df$bldgdepth)
summary(df$bldgdepth)
# Replacing NAs with medians for each corresponding borough:
df$bldgdepth[is.na(df$bldgdepth)] <- fill_NAs_median(df, "bldgdepth")
#######################################################################################################################################

# ext
class(df$ext)
summary(df$ext)
# Convert to 2 levels: 1 for extension for E, EG, and G, and 0 for no extension (blank):
levels(df$ext)[levels(df$ext)!=""] <- 1
levels(df$ext)[levels(df$ext)==""] <- 0
levels(df$ext)
#######################################################################################################################################

# proxcode
class(df$proxcode)
summary(df$proxcode)
# Convert 3s to 2s to have only 1 indicator for attached instead of sepearte indicators for attached and semi-attached.
# (I.E. Semi-attached comes under attached, level 1 for detached and level 2 for attached.)
df$proxcode[df$proxcode==3] <- 2
# Converting NAs to zeroes since 0 is not available:
df$proxcode[is.na(df$proxcode)] <- 0
# Convert to factor:
df$proxcode <- as.factor(df$proxcode)
levels(df$proxcode)
#######################################################################################################################################

# irrlotcode
class(df$irrlotcode)
summary(df["irrlotcode"])
levels(df$irrlotcode)
# Only few blanks and since the vast majority is N, blanks replaced with N:
df$irrlotcode[df$irrlotcode==""] <- "N"
df$irrlotcode <- droplevels(df$irrlotcode)
levels(df$irrlotcode)
#######################################################################################################################################

# lottype
class(df$lottype)
summary(df$lottype)
# NAs converted to 0s since 0 is unknown.
df$lottype[is.na(df$lottype)] <- 0
# Convert to factor:
df$lottype <- as.factor(df$lottype)
levels(df$lottype)
#######################################################################################################################################

# bsmtcode
# Deleted since it provides unnecessary details:
df <- subset(df, select = -c(bsmtcode))
#######################################################################################################################################

# assessland
class(df$assessland)
summary(df$assessland)
boxplot(df$assessland)
hist(df$assessland)
# Replace NAs by zero
df$assessland[is.na(df$assessland)] <- 0
# Delete all values equal to zero
df <- filter(df, assessland !=0)
#######################################################################################################################################

# assesstot
class(df$assesstot)
summary(df$assesstot)
str(df$assesstot)
boxplot(df$assesstot)
hist(df$assesstot)
#######################################################################################################################################

# exemptland
# Deleted since tax exemption related to factors other than just the location:
df <- subset(df, select = -c(exemptland))
#######################################################################################################################################

# exempttot
# Deleted since tax exemption related to factors other than the location alone (such as the business present there):
df <- subset(df, select = -c(exempttot))
#######################################################################################################################################

# yearbuilt
class(df$yearbuilt)
# Plot the data (we have some zeros):
library(ggplot2)
ggplot(df, aes(x=yearbuilt)) + geom_histogram() +
  labs(title="Year built",x="Year", y = "Count")

table(is.na(df$yearbuilt)) # No NAs

#Mode function:
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# Replace zeroes with mode when the building is built:
df$yearbuilt <- ifelse(df$yearbuilt == 0 & df$bldgarea != 0, getmode(df$yearbuilt), df$yearbuilt)

#Delete year build 2040
levels(as.factor(df$yearbuilt))
#######################################################################################################################################

# yearalter1 & yearalter2
# If yearalter2 is empty than take yearalter1, otherwise keep 0, which means that the bulding was not 
# modified at all:
class(df$yearalter1)
df$yearalter3 <- ifelse(df$yearalter2 == 0 , df$yearalter1, df$yearalter2)
# Change the name of the column:
names(df)[names(df) == "yearalter3"] <- "yearalter"
# Delete previous columns yearalter1 & yearalter2:
df <- subset(df, select = -c(yearalter2))
df <- subset(df, select = -c(yearalter1))
#######################################################################################################################################

# histdist
table(df$histdist == "")
# Deleted since 824388 blanks:
df <- subset(df, select = -c(histdist))
#######################################################################################################################################

# landmark
table(df$landmark == "")
# Delted since 853283 blanks:
df <- subset(df, select = -c(landmark))
#######################################################################################################################################

# builtfar deleted since we have the values for computing this ratio in other variables
df <- subset(df, select = -c(builtfar))
#######################################################################################################################################

# Variables residfar, commfar, and failfar deleted since they provide unnecessary extra information:
df <- subset(df, select = -c(residfar))
df <- subset(df, select = -c(commfar))
df <- subset(df, select = -c(facilfar))
#######################################################################################################################################

# borocode
class(df$borocode)
summary(df$borocode) # No NAs
# Convert to factor:
df$borocode <- as.factor(df$borocode)
levels(df$borocode)
#######################################################################################################################################

# bbl deleted since it is a combination of borough, block, and lot information:
df <- subset(df, select = -c(bbl))
#######################################################################################################################################

# condono deleted since it is unnecessary for predictions and contains mostly zeroes:
df <- subset(df, select = -c(condono))
#######################################################################################################################################

# tract2010 deleted since census data merged with zip code:
df <- subset(df, select = -c(tract2010))
#######################################################################################################################################

# xcoord and ycoor kept for visualization but not predictions.
# zonemap deleted since it is not required for visualization:
df <- subset(df, select = -c(zmcode))
#######################################################################################################################################

# zmcode deleted since assumed that buildings are in only 1 zone:
df <- subset(df, select = -c(zonemap))
#######################################################################################################################################

# sanborn deleted since this information is present in tax block and lot:
df <- subset(df, select = -c(sanborn))
#######################################################################################################################################

# taxmap deleted since it refers to a volume number which is unnecessay information:
df <- subset(df, select = -c(taxmap))
#######################################################################################################################################

# edesignum
# E codes mean that there is some hazardous material affecting this property. These are converted to 1 here.
class(df$edesignum)
df$edesignum <- as.character(df$edesignum) # Convert to character
df$edesignum[df$edesignum == ""] <- "0" # If empty, then replace with 0
df$edesignum[df$edesignum != "0"] <- "1" # If not zero, then replace with 1
df$edesignum <- as.factor(df$edesignum) # Save as factor
levels(df$edesignum)
#######################################################################################################################################

# appbbl deleted since it contains information already present in borough, block, and lot:
df <- subset(df, select = -c(appbbl))
#######################################################################################################################################

# appdate
str(df$appdate)
# Deleted since it has 5102 levels and this is extra information not needed for the predictions:
df <- subset(df, select = -c(appdate))
#######################################################################################################################################

# mappluto_f
summary(df$mappluto_f)
# Deleted since it contains 854691 NAs:
df <- subset(df, select = -c(mappluto_f))
#######################################################################################################################################

# plutomapid deleted since zipcode used instead for merging with census data:
df <- subset(df, select = -c(plutomapid))
#######################################################################################################################################

# version
summary(df$version)
# Deleted since it has only 1 level, which is version 18v2.1:
df <- subset(df, select = -c(version))
#######################################################################################################################################

# sanitdistrict
class(df$sanitdistrict)
table(is.na(df$sanitdistrict)) # 978 NAs
# Replace NAs with random sanitdistrict values of the corresponding boroughs and converting to factor:
df$sanitdistrict[is.na(df$sanitdistrict)] <- fill_NAs_by_zipcode(df,"sanitdistrict")
df$sanitdistrict <- as.factor(df$sanitdistrict)
levels(df$sanitdistrict) # 27 levels
#######################################################################################################################################

# healthcenterdistrict
class(df$healthcenterdistrict)
table(is.na(df$healthcenterdistrict)) # 834 NAs
# Replace NAs with random healthcenterdistrict values of the corresponding boroughs and converting to factor:
df$healthcenterdistrict[is.na(df$healthcenterdistrict)] <- fill_NAs_by_zipcode(df,"healthcenterdistrict")
df$healthcenterdistrict <- as.factor(df$healthcenterdistrict)
levels(df$healthcenterdistrict)
#######################################################################################################################################

# firm07_flag deleted since more recent 2015 data present:
df <- subset(df, select = -c(firm07_flag))
#######################################################################################################################################

# pfirm15_flag indicates if a tax lot is vulnerable to flooding.
class(df$pfirm15_flag)
table(is.na(df$pfirm15_flag))
# 92% of the data is NAs and these are replaced with 0s:
df$pfirm15_flag[is.na(df$pfirm15_flag)] <- 0
# Convert to factor:
df$pfirm15_flag <- as.factor(df$pfirm15_flag)
levels(df$pfirm15_flag)
#######################################################################################################################################

# rpaddate
summary(df$rpaddate)
# Deleted since only 1 date present here:
df <- subset(df, select = -c(rpaddate))
#######################################################################################################################################

# dcasdate
summary(df$dcasdate)
# Deleted since only 1 date present here:
df <- subset(df, select = -c(dcasdate))
#######################################################################################################################################

# zoningdate
summary(df$zoningdate)
# Deleted since only 1 date present here:
df <- subset(df, select = -c(zoningdate))
#######################################################################################################################################

# landmkdate
summary(df$landmkdate)
# Deleted since only 1 date present here:
df <- subset(df, select = -c(landmkdate))
#######################################################################################################################################

# basempdate
summary(df$basempdate)
# Deleted since only 1 date present here:
df <- subset(df, select = -c(basempdate))
#######################################################################################################################################

# masdate
summary(df$masdate)
# Deleted since all data is NA:
df <- subset(df, select = -c(masdate))
#######################################################################################################################################

# polidate
summary(df$polidate)
# Deleted since all data is NA:
df <- subset(df, select = -c(polidate))
#######################################################################################################################################

# edesigdate
table(df$edesigdate)
# Deleted since only 1 date present here:
df <- subset(df, select = -c(edesigdate))
#######################################################################################################################################

# Deleting borough since we have borocode. It was used at the beginning to remove erronous values:
df <- subset(df, select = -c(borough))
#######################################################################################################################################

# Writing the new partially cleaned CSV file:
write.csv(df, file = "pluto2.csv")
#######################################################################################################################################