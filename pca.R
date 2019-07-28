source("libraries.R")
df <- read.csv("pluto4.csv")
col_var <- c("block","lot","cd","schooldist","council","zipcode","firecomp","policeprct",
             "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
             "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
             "healthcenterdistrict", "pfirm15_flag")

# Keep numeric variables for assessland and assesstot predictions:
df <- select(df, -c(col_var, "assessland", "assesstot"))
df.pca <- princomp(df, cor = T) # cor=T for scaled data
df.pca$loadings