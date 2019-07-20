get_sample<-function(b, col_per_zipcode, colname) { # Get a sample where the zipcode is equal to the received one
  list_to_sample <- col_per_zipcode[colname][col_per_zipcode["zipcode"]==b]
  if (length(list_to_sample)==0) { # If all rows have NAs for that colname for the given zipcode, return NA.
    return (NA) # These NAs are deleted in the main code.
  }
  return (sample(list_to_sample, size=1)) 
}

fill_NAs_by_zipcode <- function(df, colname) {
  col_per_zipcode <- unique(df[,c("zipcode", colname)]) #keep unique values for each zipcode
  col_per_zipcode <- col_per_zipcode[!(is.na(col_per_zipcode[colname])), ] #remove NAs
  return (sapply(df["zipcode"][is.na(df[colname])], FUN=get_sample, col_per_zipcode, colname))
}

library(dplyr)
get_median<-function(b, col_per_zipcode, colname){
  index <- which(col_per_zipcode["zipcode"]==b)
  if (length(index)==0) { # If all rows have NAs for that colname for the given zipcode, return NA.
    return (NA) # These NAs are delted in the main code.
  }
  return (unlist(col_per_zipcode[index, colname]))
}
fill_NAs_median<-function(df, colname) {
  col_per_zipcode <- df[,c("zipcode", colname)]
  col_per_zipcode <- col_per_zipcode[!(is.na(col_per_zipcode[colname])), ]
  col_per_zipcode <- col_per_zipcode[!(is.na(col_per_zipcode["zipcode"])), ]
  col_per_zipcode <- col_per_zipcode %>% group_by_at("zipcode") %>% summarise_at(vars(colname), median)
  return (sapply(df["zipcode"][is.na(df[colname])], FUN=get_median, col_per_zipcode, colname))
}

