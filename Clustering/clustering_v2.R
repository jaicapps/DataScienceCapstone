## Clustering with numerical data only

## Read stuff
source("libraries.R")
source("data_type_fun.R")
df <- read.csv("pluto3.csv")
df <- data_type(df)



## Choose only numerical values
#Specify what are factors
col_var <- c("block","lot","cd","schooldist","council",
             #"zipcode", We need zipcode for visualization.
             "firecomp","policeprct",
             "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
             "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
             "healthcenterdistrict", "pfirm15_flag","xcoord", "ycoord")

#Dont choose factors
df_num <- select(df, -c(col_var))

#Aggregate by unique_block
df_new_agg = aggregate(df_new_numb,
                by = list(df_new_numb$unique_block),
                FUN = mean)


#delete zipcode & uniqueblock
df_new_agg <- select(df_new_agg, -c('zipcode','unique_block'))
#Change a name of groupping value
colnames(df_new_agg)[which(names(df_new_agg) == "Group.1")] <- "unique_block"


#Merge zipcode to aggregated data
merge(df_new_agg,to_merge, all.x = TRUE, by='unique_block')
