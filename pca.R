source("libraries.R")
df <- read.csv("sample/sample_0.011.csv")
col_var <- c("block","lot","cd","schooldist","council","zipcode","firecomp","policeprct",
             "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
             "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
             "healthcenterdistrict", "pfirm15_flag")

# Keep numeric variables for assessland and assesstot predictions:
df1 <- select(df, -c(col_var, "assessland", "assesstot"))
df1.pca <- princomp(df1, cor = T) # cor=T for scaled data
df1.pca$loadings

pcs <- df1.pca$scores[,1:15]

# Combining the PCs with the categorical variables of df and removing the numeric:
df <- select(df, c(col_var))
df <- cbind(df, pcs)
write.csv(df, file = "sample/sample_PCA.csv", row.names = FALSE)