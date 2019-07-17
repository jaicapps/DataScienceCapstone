get_sample<-function(b, col_per_zipcode, colname) { #get a sample where the zipcode is equal to the received 
  return (sample(col_per_zipcode[colname][col_per_zipcode["zipcode"]==b],1)) 
}

fill_NAs_by_zipcode <- function(df, colname) {
  col_per_zipcode <- unique(df[c("zipcode", colname)]) #keep unique values for each zipcode
  col_per_zipcode <- col_per_zipcode[!(is.na(col_per_zipcode[colname])), ] #remove NAs
  df[colname][is.na(df[colname])] <- unlist(lapply(df["zipcode"][is.na(df[colname])], FUN=get_sample, col_per_zipcode, colname))
}

#install.packages("dplyr")
library(dplyr)
get_median<-function(b, col_per_zipcode, colname){
  return (col_per_zipcode[which(col_per_zipcode["zipcode"]==b), colname])
}
fill_NAs_median<-function(df, colname) {
  col_per_zipcode <- df[c("zipcode", colname)] %>% group_by_at("zipcode") %>% na.omit()  %>% summarise_at(vars(colname), median)
  df[colname][is.na(df[colname])] <- unlist(lapply(df["zipcode"][is.na(df[colname])], FUN=get_median, col_per_zipcode, colname))
}

