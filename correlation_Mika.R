df <- read.csv("pluto2.csv")

#chisq.test example
df$borocode <- as.factor(df$borocode)
df$healtharea <- as.factor(df$healtharea)
colnames(df)
chisq.test(df$healthcenterdistrict, df$borocode, simulate.p.value = TRUE)

#keep variables related with location 
location_vars <- c("schooldist","council","zipcode","firecomp",
                   "policeprct","healtharea","sanitboro","sanitsub","zonedist1","spdist1",
                   "irrlotcode","borocode","sanitdistrict","healthcenterdistrict","pfirm15_flag")

#test correlation with assestot
library(dplyr)
df2 <- select(df, c("assesstot","assessland", location_vars))
df2[location_vars] <- lapply(df2[location_vars], factor)  

fit <- aov(assesstot ~ schooldist, data=df2)





