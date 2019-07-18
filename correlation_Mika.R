df <- read.csv("pluto2.csv")

#keep variables related with location 
location_vars <- c("schooldist","council","zipcode","firecomp",
                   "policeprct","healtharea","sanitboro","sanitsub","zonedist1","spdist1",
                   "irrlotcode","borocode","sanitdistrict","healthcenterdistrict","pfirm15_flag")

#test correlation with assestot and assesland
library(dplyr)
df <- select(df, c("assesstot","assessland", location_vars))
df[location_vars] <- lapply(df[location_vars], factor)  


result <- data.frame()
for(i in location_vars) {
    print(paste("Test assesstot vs", i))
    fit <- aov(assesstot ~ df[,i], data=df)
    print(summary(fit))
    print(unlist(summary(fit)))
    result["assesstot",i] <- unlist(summary(fit))["Pr(>F)1"]
    
    print(paste("Test assessland vs", i))
    fit <- aov(assessland ~ df[,i], data=df)
    print(summary(fit))
    print(unlist(summary(fit)))
    result["assessland",i] <- unlist(summary(fit))["Pr(>F)1"]
}



