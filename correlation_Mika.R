df <- read.csv("pluto2.csv")
df$borocode <- as.factor(df$borocode)
df$healtharea <- as.factor(df$healtharea)
colnames(df)
chisq.test(df$healthcenterdistrict, df$borocode, simulate.p.value = TRUE)


location_vars <- c("schooldist","council","zipcode","firecomp",
          "policeprct","healtharea","sanitboro","sanitsub","zonedist1","spdist1",
           "irrlotcode","borocode","sanitdistrict","healthcenterdistrict","pfirm15_flag")
