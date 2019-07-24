#http://www.sthda.com/english/articles/37-model-selection-essentials-in-r/153-penalized-regression-essentials-ridge-lasso-elastic-net/
source("data_type_fun.R")
source("libraries.R")
library(tidyverse)
library(caret)
#install.packages("glmnet", repos = "http://cran.us.r-project.org")
library(glmnet)
library(parallel)
library(doMC)
no_cores <- max(1, detectCores() - 2)

df <- read.csv("pluto4.csv")
df <- data_type(df)

dep_var1 = c("cd", "council", "firecomp", "policeprct", "healtharea",
           "sanitboro", "sanitsub", "sanitdistrict", "healthcenterdistrict", 
           "block", "xcoord", "ycoord","block", "lot", "borocode",
           "xcoord", "ycoord", "assessland", "zipcode")

dep_var2 = c("facilfar", "schooldist", "zonedist1", "spdist1", 
             "landuse", "ext", "proxcode", "irrlotcode", "edesignum", "pfirm15_flag")

df <- df[, !(colnames(df) %in% dep_var1)]
df <- df[,!(colnames(df) %in% dep_var2)]
# Split the data into training and test set
set.seed(123)
training.samples <- df$assesstot %>% createDataPartition(p = 0.8, list = FALSE)
train.data  <- df[training.samples, ]
test.data <- df[-training.samples, ]

# Predictor variables: transform categorical to dummpy 
x <- model.matrix(assesstot~., train.data)[,-1]

# Outcome variable
y <- train.data$assesstot

# Find the best lambda using cross-validation (lambda is to penalize)
set.seed(123)
registerDoMC(cores=no_cores)
cv <- cv.glmnet(x, y, alpha = 1, parallel = TRUE) # lasso regression alpha=1
# Display the best lambda value
print(paste("min lambda", cv$lambda.min))

print("Fitting final model on the training data")
# Fit the final model on the training data
model <- glmnet(x, y, alpha = 1, lambda = cv$lambda.min)
# Display regression coefficients
print("Coefficients:")
c <- as.data.frame(coef(model))
print(coef(model))

print("Predictions on the test data")
x.test <- model.matrix(assesstot ~., test.data)[,-1]
predictions <- model %>% predict(x.test) %>% as.vector()
# Model performance metrics
result <- data.frame(
  RMSE = RMSE(predictions, test.data$assesstot),
  Rsquare = R2(predictions, test.data$assesstot)
)
write.csv(result, "result.csv")

