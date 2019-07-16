get_sample<-function(b, col_per_borough, colname) { #get a sample where the borough is equal to the received 
  return (sample(col_per_borough[colname][col_per_borough["borough"]==b],1)) 
}

fill_NAs_by_borough <- function(df, colname) {
  col_per_borough <- unique(df[c("borough", colname)]) #keep unique values for each borough
  col_per_borough <- col_per_borough[!(is.na(col_per_borough[colname])), ] #remove NAs
  df[colname][is.na(df[colname])] <- unlist(lapply(df["borough"][is.na(df[colname])], FUN=get_sample, col_per_borough, colname))
}

#install.packages("dplyr")
library(dplyr)
get_median<-function(b, col_per_borough, colname){
  return (col_per_borough[which(col_per_borough["borough"]==b), colname])
}
fill_NAs_median<-function(df, colname) {
  col_per_borough <- df[c("borough", colname)] %>% group_by_at("borough") %>% na.omit()  %>% summarise_at(vars(colname), median)
  df[colname][is.na(df[colname])] <- unlist(lapply(df["borough"][is.na(df[colname])], FUN=get_median, col_per_borough, colname))
}

