# Loading the libraries required:
library(glmnet)
library(caret)
source("data_type_fun.R")
source("libraries.R")

df <- read.csv("sample/sample_0.011.csv")

# Delete block and lot:
df <- subset(df, select = -c(block,lot))
numeric <- c("lotarea", "bldgarea","numbldgs","numfloors","unitsres","unitstotal","lotfront",
             "lotdepth","bldgfront","bldgdepth","assessland","assesstot","yearbuilt",
             "residfar","commfar","facilfar","xcoord","ycoord","yearalter", "income")

# Convert to factors:
df <- data_type(df)

# Convert to dummies:
dmy <- dummyVars("~.", data = df, fullRank = T)
df <- data.frame(predict(dmy, newdata = df)) # Have to convert to dummies for avoiding 
#the error of some factors' levels present in training set but not in test set.

# Scaling numeric variables:
# Loop over each column.
for (colName in names(df)) {
  
  # Check if the column contains numeric data.
  if(class(df[,colName]) == 'integer' | class(df[,colName]) == 'numeric') {
    
    # Scale this column (scale() function applies z-scaling).
    df[,colName] <- scale(df[,colName])
  }
}

# Since we're predicting assessland:
df <- subset(df, select = -c(assesstot))
str(df)

# Getting the independent variables:
x_var <- data.matrix(subset(df, select = -c(assessland)))

# Getting the dependent variable:
y_var <- df[,'assessland']

# Linear regression:
library(caret)
# Split data into train and test
index <- createDataPartition(df$assessland, p = .80, list = FALSE)
train <- df[index, ]
test <- df[-index, ]

# Taining model
lmModel <- lm(assessland ~ . , data = train)
# Printing the model object
print(lmModel)

library(Metrics)
rmse(actual = train$assessland, predicted = lmModel$fitted.values) #40,507.97

hist(lmModel$residuals)
#plot(lmModel)

# Predicting assessland in test dataset
test$predassessland <- predict(lmModel, test)
# Priting top 6 rows of actual and predited price
head(test[ , c("assessland", "predassessland")])

# R squared value:
actual <- test$assessland
preds <- test$predassessland
rss <- sum((preds - actual) ^ 2)
tss <- sum((actual - mean(actual)) ^ 2)
rsq <- 1 - rss/tss
rsq #0.2519