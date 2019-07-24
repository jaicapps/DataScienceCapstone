# Chi-squared test for independence between categorical variables:

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

# Those variables for which the independence hypothesis is not rejeceted:
a <- colnames(df1)
j <- 0
print("These pairs of variables might be independent:")
for (i in 1:dim(df1)[1]){
  for (j in 1:dim(df1)[2]){
    if((j >= i) & (df1[a[i],a[j]] > 0.05)){
      print(c(a[i],a[j]))
    }
  }
}

# Upper triangle values of chi-squared values saved in a data frame:
d <- as.data.frame(upperTriangle(df2, diag = TRUE, byrow = TRUE))
colnames(d) <- "value"

library(ggplot2)
ggplot(data=d, aes(d$value)) + geom_histogram()
ggplot(data=d, aes(d$value)) + geom_histogram() + ylim(0,5)
ggplot(data=d, aes(d$value)) + geom_histogram() + ylim(0,10) + xlim(0,3e+9)
dt <- as.table(as.matrix(df2))

# Choosing a threshold chi-squared value based on the above graphs:
m = 8.0e+09

# Displaying those points that are greater than this threshold in skyblue color:
a <- colnames(df2)
df3 <- df2
for (i in a){
  for (j in a){
    if (df3[i, j]>=m) {
      df3[i, j] <- "skyblue"
    }
    else{
      df3[i,j] <- "white"
    }
  }
}

# White for the lower triangle (without diagonal), so that only upper triangle is displayed in the plot:
df3[lower.tri(df3, diag = FALSE)] <- "white" # diag = FALSE by default
df3 <- as.table(as.matrix(df3))

# Balloon plot:
library("gplots")
gplots::balloonplot(df3, main ="Independence Test", xlab ="", ylab="",
            label = FALSE, show.margins = FALSE, colsrt=90, dotcolor = df3,
            hide.duplicates=TRUE, text.size=0.5)
# Remember that lot is indepent with respect to healtharea, sanitsub, and ltdheight.
