#http://www.sthda.com/english/articles/37-model-selection-essentials-in-r/153-penalized-regression-essentials-ridge-lasso-elastic-net/
library(tidyverse)
library(caret)
#install.packages("glmnet", repos = "http://cran.us.r-project.org")
library(glmnet)
# Load the data
#data("Boston", package = "MASS")

# Split the data into training and test set
set.seed(123)
training.samples <- df$assesstot %>% createDataPartition(p = 0.8, list = FALSE)
train.data  <- df[training.samples, ]
test.data <- df[-training.samples, ]
# Predictor variables: transform categorical to dummpy 
x <- model.matrix(assesstot~., train.data)[,-1]
# Outcome variable
y <- train.data$assesstot
glmnet(x, y, alpha = 1, lambda = NULL)


# Find the best lambda using cross-validation (lambda is to penalize)
set.seed(123) 
cv <- cv.glmnet(x, y, alpha = 0)
# Display the best lambda value
cv$lambda.min

# Fit the final model on the training data
model <- glmnet(x, y, alpha = 0, lambda = cv$lambda.min)
# Display regression coefficients
coef(model)
# Make predictions on the test data
x.test <- model.matrix(assesstot ~., test.data)[,-1]
predictions <- model %>% predict(x.test) %>% as.vector()
# Model performance metrics
data.frame(
  RMSE = RMSE(predictions, test.data$assesstot),
  Rsquare = R2(predictions, test.data$assesstot)
)

