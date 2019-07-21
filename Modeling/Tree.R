# Read data and change types:
df <- read.csv("pluto2.csv")
source("data_type_fun.R")
source("libraries.R")
df <- data_type(df)


# Choose columns with small level (lower than 53)
df <- subset(df ,select = -c(block, lot, zipcode, firecomp, policeprct, healtharea,sanitsub))

# Sample for test
sample <- sample_n(df, 100)

library(randomForest)
rf <- randomForest(assesstot ~ ., data = sample, ntree = 500, nodesize = 5, importance = TRUE)  
# Can not handle categorical predictors with more than 53 categories.
varImpPlot(rf, type = 1)
