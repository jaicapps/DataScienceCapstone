#http://www.sthda.com/english/articles/37-model-selection-essentials-in-r/153-penalized-regression-essentials-ridge-lasso-elastic-net/
library(tidyverse)
library(caret)
#install.packages("glmnet", repos = "http://cran.us.r-project.org")
library(glmnet)
library(parallel)
library(doMC)
no_cores <- max(1, detectCores() - 2)
# Load the data
#df <- na.omit(df)
#write.csv(df, "df.csv")
df <- read.csv("df.csv")
categorical_vars <- c("block","lot","cd","schooldist","council","zipcode","firecomp",
"policeprct","healtharea","sanitboro","sanitsub","zonedist1","spdist1",
"landuse","ext","proxcode","irrlotcode","lottype","borocode","sanitdistrict",
"healthcenterdistrict","pfirm15_flag")
#TODO: remove X 
df[categorical_vars] <- lapply(df[categorical_vars], as.factor) 

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
write.csv(coef(model), "coef.csv")
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

