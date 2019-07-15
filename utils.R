get_sample_cd<-function(b, col_per_borough, colname) { #get a sample where the borough is equal to the received 
  return (sample(col_per_borough[colname][col_per_borough["borough"]==b],1)) 
}

fill_NAs_by_borough <- function(df, colname) {
  col_per_borough <- unique(df[c("borough", colname)]) #keep unique values for each borough
  col_per_borough <- col_per_borough[!(is.na(col_per_borough[colname])), ] #remove NAs
  df[colname][is.na(df[colname])] <- unlist(lapply(df["borough"][is.na(df[colname])], FUN=get_sample_cd, col_per_borough, colname))
}

