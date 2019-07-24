library("gdata")
df <- read.csv("correlation/factors_chi2.csv")
row.names(df) <- colnames(df)

# p values:
df1 <- df
for (i in colnames(df1)) {
  df1[,i] <- gsub(".*,(.*)", "\\1", df1[,i])
  df1[,i] <- as.numeric(df1[,i])
}

# Chi-squared values:
df2 <- df
for (i in colnames(df2)) {
  df2[,i] <- gsub("(.*),.*", "\\1", df2[,i])
  df2[,i] <- as.numeric(df2[,i])
}

# # Those variables for which the independence hypothesis is not rejeceted:
# a <- colnames(df1)
# print("These pairs of variables might be independent:")
# for (i in 1:dim(df1)[1]){
#   for (j in 1:dim(df1)[2] + 1 - i){
#     if(df1[a[i],a[j]] < 0.05){
#       paste(i,j)
#     }
#   }
# }

# Upper triangle values of chi-squared values saved in a data frame:
d <- as.data.frame(upperTriangle(df2, diag = TRUE, byrow = TRUE))
colnames(d) <- "value"

library(ggplot2)
ggplot(data=d, aes(d$value)) + geom_histogram()
dt <- as.table(as.matrix(df2))

m = 5.0e+6
a <- colnames(df2)
df3 <- df2
for (i in a){
  for (j in a){
    if (df3[i, j]>=m) {
      df3[i, j] <- "white"
    }
    else{
      df3[i,j] <- "skyblue"
    }
  }
}

# White for the lower triangle (without diagonal), so that only upper triangle is displayed in the plot:
df3[lower.tri(df3, diag = FALSE)] <- "white" # diag = FALSE by default
df3 <- as.table(as.matrix(df3))

library("gplots")
gplots::balloonplot(t(df3), main ="Independence Test", xlab ="", ylab="",
            label = FALSE, show.margins = FALSE, colsrt=90, dotcolor = df3,
            hide.duplicates=TRUE, text.size=0.5)


