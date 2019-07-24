df <- read.csv("correlation/df_all.csv")

# Delete assess total and assesset land from data
df <- df[!(df$X %in% c('assesstot', 'assessland')), ]

#Tukey Test
library(agricolae)
data("PlantGrowth")

plant.lm <- lm(weight ~ group, data = PlantGrowth)
plant.av <- aov(plant.lm)
summary(plant.av)


df2 <- df<0.05
table(df2)
class(df2)
