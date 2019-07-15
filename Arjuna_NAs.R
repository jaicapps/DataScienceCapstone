df=read.csv("pluto_18v2_1.csv")
t(t(colnames(df)))

summary(df$ext)
# Convert to 2 levels: 1 for extension for E, EG, and G, and 0 for no extension (blank):
levels(df$ext)[levels(df$ext)!=""] <- 1
levels(df$ext)[levels(df$ext)==""] <- 0
summary(df$ext)

summary(df$proxcode)
class(df$proxcode)
# Convert 3s to 2s to have only 1 level for attached instead of a sepearte level for attached and semi-attached.
# I.E. Semi-attached comes under attached. Level 2: Attached
df$proxcode[df$proxcode==3] <- 2
# Converting NAs to zeroes since 0 is not available:
df$proxcode[is.na(df$proxcode)] <- 0
# Converting to factor since 0 to 3 has different meanings (PDF):
df$proxcode <- as.factor(df$proxcode)
summary(df$proxcode)

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
# Deleted since it is too detailed: 
df <- subset(df, select = -c(bsmtcode))
