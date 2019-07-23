df <- read.csv("correlation/factors_chi2.csv")
row.names(df) <- colnames(df)
df1 <- df
for (i in colnames(df1)) {
  df1[,i] <- gsub(".*,(.*)", "\\1", df1[,i])
}

a <- colnames(df1)
df3 <- data.frame()
for (i in 1:24){
  for (j in 1:(25-i)){
    df3[a[i],a[j]] <- df1[i,j]
  }
}

df2 <- df
for (i in colnames(df2)) {
  df2[,i] <- gsub("(.*),.*", "\\1", df2[,i])
}

library("gplots")
dt <- as.table(as.matrix(df2))
m <- median(as.numeric(as.vector(as.matrix(df2))))
colors=ifelse(x>m,"green","magenta") 
balloonplot(t(dt), main ="Independence Test", xlab ="", ylab="",
            label = FALSE, show.margins = FALSE, colsrt=90, dotcolor=)