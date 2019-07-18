library(dplyr)
df2 <- na.omit(df)
sample <- sample_n(df2, 100)

library(randomForest)
rf <- randomForest(assesstot ~ ., data = sample, ntree = 500, nodesize = 5, importance = TRUE)  
# Can not handle categorical predictors with more than 53 categories.