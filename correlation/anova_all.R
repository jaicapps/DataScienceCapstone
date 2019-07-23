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

### After receiving results, read the data again.
anova <- read.csv("correlation/anova_all.csv")

# Delete assess total and assesset land from data
anova <- anova[!(anova$X %in% c('assesstot', 'assessland')), ]

#Tukey Test

library(agricolae)
data("PlantGrowth")

plant.lm <- lm(weight ~ group, data = PlantGrowth)
plant.av <- aov(plant.lm)
summary(plant.av)


anova2 <- anova<0.05
table(anova2)
class(anova2)
