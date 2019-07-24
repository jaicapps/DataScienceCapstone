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



## Clustering with 2 different approaches:

## Method I.
#Aggregate the data first and later make clusters
df <- read.csv("pluto3.csv")
#Specify what are factors
col_var <- c("block","lot","cd","schooldist","council",
             #"zipcode", We need zipcode to group by this.
             "firecomp","policeprct",
             "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
             "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
             "healthcenterdistrict", "pfirm15_flag")
#Dont choose factors
df <- select(df, -c(col_var, "xcoord", "ycoord"))

#Aggregate by zipcode
agg = aggregate(df,
                by = list(df$zipcode),
                FUN = mean) # with median everything is in only one class.

#Cluster but on zipcode level
mc_zips <- Mclust(agg[, !names(agg) %in% c("Group.1",'zipcode')])
summary(mc_zips)
agg_clust <- cbind(mc_zips$classification, agg)
#rename column
colnames(agg_clust)[which(names(agg_clust) == "mc_zips$classification")] <- "Clust_M"
#select only class + zipcode
agg_clust <- select(agg_clust, zipcode, Clust_M)

write.csv(agg_clust,  file = "Clustering/cluster_zips_method1.csv")


## Method II
#make clusters and later aggregate data taking the mode for given zipcode
method2 <- read.csv("Clustering/df_model.csv")
method2 <- select(method2, Clust_M,zipcode)

#mode function
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

#aggregate
agg_method2 = aggregate(Clust_M ~ zipcode , method2, Mode)

#write.csv(agg_method2,  file = "Clustering/cluster_zips_method2.csv")






#########################################

## K-means clustering

#similar to method I
#Scale data
kmeans_df <- scale(agg[, !names(agg) %in% c("Group.1",'zipcode')])

#Function to check # of clusters in a data
plot.wgss = function(mydata, maxc) {
  wss = numeric(maxc)
  for (i in 1:maxc)
    wss[i] = kmeans(mydata, centers=i, nstart = 10)$tot.withinss
  plot(1:maxc, wss, type="b", xlab="Number of Clusters",
       ylab="Within groups sum of squares", main="Scree Plot")
}

## scree plot, VERY SLOW
scree_plot2 <- plot.wgss(kmeans_df, 20)

# do it
km <- kmeans(kmeans_df, centers=4, nstart = 20)
table(km$cluster)

kmeans_1 <- cbind(km$cluster, agg)
kmeans_1 <- select(kmeans_1, zipcode, `km$cluster`)  
   
write.csv(kmeans_1,  file = "Clustering/kmeans_method1.csv")
