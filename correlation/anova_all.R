df <- read.csv("pluto3.csv")
categorical_vars <- c("lot","cd","schooldist","council","zipcode","firecomp","policeprct",
                      "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
                      "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
                      "healthcenterdistrict", "pfirm15_flag") #remove block
#keep numeric vars
numeric_vars <- setdiff(colnames(df), c(categorical_vars, "xcoord", "ycoord", "block"))

#transform to factor categorical variables
df[categorical_vars] <- lapply(df[categorical_vars], factor)
result <- data.frame()
for (i in numeric_vars) {
  for (j in categorical_vars) {
    print(paste(i, j, sep=" and "))
    fit <- aov(df[,i] ~ df[,j], data=df)
    print(summary(fit))
    print(unlist(summary(fit)))
    result[i,j] <- unlist(summary(fit))["Pr(>F)1"]
  }
}
write.csv(result,"anova_all.csv")
