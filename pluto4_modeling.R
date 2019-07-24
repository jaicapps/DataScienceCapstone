library("dplyr")
df <- read.csv("pluto3.csv")
table(df$zipcode==11430) # Outliers as seen from Tableau. JFK airport that has too high of an 
# assessed land and assessed total
table(df$zipcode == 12345) # Outlier as seen from Tableau.
df <- filter(df, !(zipcode == 11430 | zipcode == 12345))
# writing to csv:
write.csv(df, file = "pluto4.csv", row.names=FALSE)

# From the correlation of numerical variables, we decide not to delete any numerical variables.

# From the chi-squared test for independence between categorical variables, we delete the following:
dep_var1 <- c("cd", "council", "zipcode", "firecomp", "policeprct", "healtharea",
              "sanitboro", "sanitsub", "sanitdistrict", "healthcenterdistrict")
# borocode was also supposed to be deleted since it is dependent, but it is kept for sampling.

# From the anova test for independence between the selected categorical and numerical variables,
# we delete the following:
# 1. Removing more categorical variables:
dep_var2 <- c("facilfar", "schooldist", "zonedist1", "spdist1", "landuse", "ext", "proxcode",
              "irrlotcode", "edesignum", "pfirm15_flag")

# 2. Removing more numerical variables:
dep_var3 <- c("irrlotcode", "numfloors", "unitsres", "lotfront", "bldgfront", "bldgdepth",
              "yearbuilt", "residfar", "commfar", "facilfar", "yearalter", "income")

# Also, we must remove the following since they are not needed for prediction:
v <- c("xcoord", "ycood", "block", "lot", "borocode")
