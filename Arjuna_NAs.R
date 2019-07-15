df=read.csv("pluto_18v2_1.csv")
t(t(colnames(df)))

summary(df["irrlotcode"])
levels(df$irrlotcode)
# Only 475 blanks and since the vast majority is N (723544 N and only 134963 Y), blanks replaced with N:
df$irrlotcode[df$irrlotcode==""] <- "N"
df$irrlotcode <- droplevels(df$irrlotcode)
summary(df$irrlotcode)

class(df$lottype)
summary(df$lottype)
# 475 NAs converted to 0s since 0 is unknown. After this, convert to factor since 0 to 9 have different meanings (given in PDF):
df$lottype[is.na(df$lottype)] <- 0
df$lottype <- as.factor(df$lottype)
summary(df$lottype)

summary(df$bsmtcode)
class(df$bsmtcode)
#475 NAs converted to 5s since 5 is unknown. After this, convert to factor since 0 to 5 have different meanings (given in PDF):
df$bsmtcode[is.na(df$bsmtcode)] <- 5
df$bsmtcode <- as.factor(df$bsmtcode)
summary(df$bsmtcode)
