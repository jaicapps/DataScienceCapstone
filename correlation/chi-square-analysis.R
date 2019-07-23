library("gdata")
df <- read.csv("correlation/factors_chi2.csv")
row.names(df) <- colnames(df)

# p values:
df1 <- df
for (i in colnames(df1)) {
  df1[,i] <- gsub(".*,(.*)", "\\1", df1[,i])
  df1[,i] <- as.numeric(df1[,i])
}

# chi-squared values:
df2 <- df
for (i in colnames(df2)) {
  df2[,i] <- gsub("(.*),.*", "\\1", df2[,i])
  df2[,i] <- as.numeric(df2[,i])
}

# Upper triangle values of df2 (chi-squared values) saved in a data frame:
d <- as.data.frame(upperTriangle(df2, diag = TRUE, byrow = TRUE))
colnames(d) <- "value"

library(ggplot2)
ggplot(data=d, aes(d$value)) + 
  geom_histogram()
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

for (i in 1:length(df2)){
  for (j in 1:length(df2)+1-i){
    df3[a[i], a[j]] <- "white"
  }
}

df3 <- as.table(as.matrix(df3))

library("gplots")
gplots::balloonplot(t(df3), main ="Independence Test", xlab ="", ylab="",
            label = FALSE, show.margins = FALSE, colsrt=90, dotcolor = df3,
            hide.duplicates=TRUE, text.size=0.5)


