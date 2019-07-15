colnames(df)
########
#borough
summary(df$borough)
table(is.na(df$borough))
#delete levels that are large
df$borough <- as.factor(df$borough)
l <- levels(df$borough)
#check amount of rows that have rare borough 
dim(df[df$borough==l[1],])
dim(df[df$borough==l[2],])
dim(df[df$borough==l[3],])
dim(df[df$borough==l[4],])
dim(df[df$borough==l[5],])
dim(df[df$borough==l[6],])
#remove rows within first 6 levels for borough(considered as rare)
dim(df)
df <- df[!(df$borough==l[1]), ]
df <- df[!(df$borough==l[2]), ]
df <- df[!(df$borough==l[3]), ]
df <- df[!(df$borough==l[4]), ]
df <- df[!(df$borough==l[5]), ]
df <- df[!(df$borough==l[6]), ]
dim(df)
df <- droplevels(df)

########
#block
table(is.na(df$block))
########
#lot
table(is.na(df$lot))
########
#cd
table(is.na(df$cd))
cd_per_borough <- unique(df[c("borough", "cd")])
cd_per_borough <- cd_per_borough[!(is.na(cd_per_borough$cd)), ]
cd_BX <- cd_per_borough[cd_per_borough$borough=="BX",]$cd
cd_BK <- cd_per_borough[cd_per_borough$borough=="BK",]$cd
sample(cd_BX, 1)
df2 <- df

df2[is.na(df2) & df2$borough=="BX"] <- sample(cd_BX, 1)

