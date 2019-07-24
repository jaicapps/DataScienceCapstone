library("dplyr")
df <- read.csv("correlation/anova_all.csv")
rownames(df) <- df$X
df <- df[,-1]
rownames(df)
# Delete assess total and assesset land from data
df <- select(df, -c("assessland", "assesstot"))

a <- colnames(df)

# p values:
df1 <- df
for (i in a) {
  df1[,i] <- gsub(".*,(.*)", "\\1", df1[,i])
  df1[,i] <- as.numeric(df1[,i])
}

# F-statistic values:
df2 <- df
for (i in a) {
  df2[,i] <- gsub("(.*),.*", "\\1", df2[,i])
  df2[,i] <- as.numeric(df2[,i])
}

# Those variables for which the independence hypothesis is not rejeceted:
b <- rownames(df1)
print("These pairs of variables might be independent:")
for (i in b){
  for (j in a){
    if((df1[i,j] > 0.05)){
      print(c(i,j))
    }
  }
}
# The variable lotarea is indepedent with respect to spdist1, ltdheight, and edesignum.

d <- c()
for (i in b){
  for (j in a){
    d <- c(d,df2[i,j])
  }
}
d <- as.data.frame(d)
colnames(d) <- "value"

library(ggplot2)
ggplot(data=d, aes(d$value)) + geom_histogram()
ggplot(data=d, aes(d$value)) + geom_histogram() + ylim(0,40)
ggplot(data=d, aes(d$value)) + geom_histogram() + ylim(0,40) + xlim(0,4e+5)

# Choosing a threshold chi-squared value based on the above graphs:
m = 3.0e+05

# Displaying those points that are greater than this threshold in skyblue color:
df3 <- df2
for (i in b){
  for (j in a){
    if (df3[i, j]>=m) {
      df3[i, j] <- "skyblue"
    }
    else{
      df3[i,j] <- "white"
    }
  }
}

df3 <- as.table(as.matrix(df3))
# Balloon plot:
library("gplots")
gplots::balloonplot(df3, main ="Independence Test", xlab ="", ylab="",
                    label = FALSE, show.margins = FALSE, colsrt=90, dotcolor = df3,
                    hide.duplicates=TRUE, text.size=0.5)
# Remember that lotarea is indepedent with respect to spdist1, ltdheight, and edesignum.
