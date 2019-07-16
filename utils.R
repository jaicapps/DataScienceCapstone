get_sample<-function(b, col_per_borocode, colname) { #get a sample where the borocode is equal to the received 
  return (sample(col_per_borocode[colname][col_per_borocode["borocode"]==b],1)) 
}

fill_NAs_by_borocode <- function(df, colname) {
  col_per_borocode <- unique(df[c("borocode", colname)]) #keep unique values for each borocode
  col_per_borocode <- col_per_borocode[!(is.na(col_per_borocode[colname])), ] #remove NAs
  df[colname][is.na(df[colname])] <- unlist(lapply(df["borocode"][is.na(df[colname])], FUN=get_sample, col_per_borocode, colname))
}

#install.packages("dplyr")
library(dplyr)
get_median<-function(b, col_per_borocode, colname){
  return (col_per_borocode[which(col_per_borocode["borocode"]==b), colname])
}
fill_NAs_median<-function(df, colname) {
  col_per_borocode <- df[c("borocode", colname)] %>% group_by_at("borocode") %>% na.omit()  %>% summarise_at(vars(colname), median)
  df[colname][is.na(df[colname])] <- unlist(lapply(df["borocode"][is.na(df[colname])], FUN=get_median, col_per_borocode, colname))
}

