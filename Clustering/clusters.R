## Clustering with numerical data only

#Read stuff
source("libraries.R")
df <- read.csv("pluto3.csv")
df <- data_type(df)

# Take the sample for trying only
#df <- sample_n(df1,100)



##### MODEL BASED Clustering ##### 
library(mclust)
#Perform clustering not using those column below. Exclude categorical variables but I want
#to keep them in df (just do use it for analysis)
mc <- Mclust(
              df[, !names(df) %in% c("block","lot","cd","schooldist","council","zipcode","firecomp","policeprct",
                                  "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
                                  "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
                                  "healthcenterdistrict", "pfirm15_flag", "xcoord", "ycoord")])

summary(mc)
#Save cluster's result to .rds
#####saveRDS(mc, file = "Clustering/result_of_Model_Based.rds")
#Combined result with all data
df_clust <- cbind(mc$classification, df)
colnames(df_clust)[which(names(df_clust) == "mc$classification")] <- "Clust_M"

#Save new df into csv
####write.csv(df_clust,  file = "Clustering/df_model.csv")




#########################################

## K-means clustering
# 
# #Scale data
# clus_df <- scale(df)
# 
# #Function to check # of clusters in a data
# plot.wgss = function(mydata, maxc) {
#   wss = numeric(maxc)
#   for (i in 1:maxc) 
#     wss[i] = kmeans(mydata, centers=i, nstart = 10)$tot.withinss 
#   plot(1:maxc, wss, type="b", xlab="Number of Clusters",
#        ylab="Within groups sum of squares", main="Scree Plot") 
# }
# 
# ## scree plot, VERY SLOW
# scree_plot2 <- plot.wgss(clus_df, 20)
