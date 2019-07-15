df <- read.csv("pluto_18v2_1.csv")
colnames(df)

# Column 'edesigdate'
# Delete the column. It has only 2 levels, check below. Delete it cuz almost all rows have the same date.
table(df$edesigdate)
df <- subset(df, select = -c(edesigdate))

# Column 'polidate'
# Delete the column. All data is NA.
summary(df$polidate)
df <- subset(df, select = -c(polidate))

# Column 'masdate'
# Delete the column. All data is NA.
summary(df$masdate)
df <- subset(df, select = -c(masdate))

# Column 'basempdate' the same explanation as # Column 'edesigdate' (column at the begining).
summary(df$basempdate)
str(df$basempdate)
df <- subset(df, select = -c(basempdate))

# Column 'landmkdate' the same explanation as # Column 'edesigdate' (column at the begining).
summary(df$landmkdate)
df <- subset(df, select = -c(landmkdate))
 
# Column 'zoningdate' the same explanation as # Column 'edesigdate' (column at the begining).
summary(df$zoningdate)
df <- subset(df, select = -c(zoningdate))

# Column 'dcasdate' the same explanation as # Column 'edesigdate' (column at the begining).
summary(df$dcasdate)
df <- subset(df, select = -c(dcasdate))

# Column 'rpaddate' the same explanation as # Column 'edesigdate' (column at the begining).
summary(df$rpaddate)
df <- subset(df, select = -c(rpaddate))

# Column 'pfirm15_flag' this column indicated if a tax lot is vulnerable to be flooded. 
# We transform NA into 0. 92% of data is 1.
summary(df$pfirm15_flag)
str(df$pfirm15_flag)
793294/858982*100 # 92%
858982-793294
# replace NA into 0
df$pfirm15_flag[is.na(df$pfirm15_flag)] <- 0
# Change type as factor
df$pfirm15_flag <- as.factor(df$pfirm15_flag)

# Column 'firm07_flag' # Decided to delete cuz we have the same data for the year 2015.
# We keep only 2015 because it is more accurate.
str(df$firm07_flag)
summary(df$firm07_flag)
df <- subset(df, select = -c(firm07_flag))

# Column 'healthcenterdistrict'
## To repare this, you have to execute Mika's code first! She repaired problem with borough lebels.
df$healthcenterdistrict <- as.factor(df$healthcenterdistrict)
str(df$healthcenterdistrict)
summary(df$healthcenterdistrict)

table(is.na(df$healthcenterdistrict))
health_per_borough <- unique(df[c("borough", "healthcenterdistrict")]) #keep cds for each borough
health_per_borough <- health_per_borough[!(is.na(health_per_borough$healthcenterdistrict)), ] #remove cd NAs
get_sample<-function(borough) { #get a sample from cds where the borough is received 
  return (sample(health_per_borough[health_per_borough$borough==borough,]$healthcenterdistrict,1)) 
}
df$healthcenterdistrict[is.na(df$healthcenterdistrict)] <- lapply(df$borough[is.na(df$healthcenterdistrict)], FUN=get_sample)

levels(df$healthcenterdistrict)

