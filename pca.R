source("libraries.R")
df <- read.csv("pluto3.csv")
col_var <- c("block","lot","cd","schooldist","council","zipcode","firecomp","policeprct",
             "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
             "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
             "healthcenterdistrict", "pfirm15_flag")

# Keep numeric variables for assessland prediction:
df <- select(df, -c(col_var, "xcoord", "ycoord", "assessland"))
df.pca <- princomp(df, cor = T) # cor=T for scaled data
df.pca$loadings

# Keep numeric variables for assesstot prediction:
df <- read.csv("pluto3.csv")
df <- select(df, -c(col_var, "xcoord", "ycoord", "assesstot"))
df.pca <- princomp(df, cor = T) # cor=T for scaled data
df.pca$loadings
