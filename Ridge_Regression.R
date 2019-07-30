# Loading the libraries required:
library(glmnet)
library(Metrics)
library(dummies)
source("data_type_fun.R")
source("libraries.R")

df <- read.csv("sample/sample_0.011.csv")

# Delete block and lot:
df <- subset(df, select = -c(block,lot))

# Convert to categorical variables:
col_var <- c("cd","schooldist","council","zipcode","firecomp","policeprct",
             "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
             "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
             "healthcenterdistrict", "pfirm15_flag")

df <- data_type(df)

x<- subset(df, select = -c(assessland))
y<- df[,'assessland']
data<-cbind(x,y)
model<-model.matrix(y~., data=data)
ridgedata= model[,-1]
train<- sample(1:dim(ridgedata)[1], round(0.8*dim(ridgedata)[1]))
test<- setdiff(1:dim(ridgedata)[1],train)
x_train <- data[train, ]
y_train <- data$y[train]
x_test <- data[test, ]
y_test <- data$y[test]
k=5 # 5 folds in cross-validation
grid =10^ seq (4,-2, length =100)
fit <- cv.glmnet(model,y,alpha=0,k=k,lambda = grid)
lambda_min<-fit$lambda.min #6579.332
newX <- model.matrix(~.-y,data=x_test)
fit_test<-predict(fit, newx=newX,s=lambda_min)

# R squared value:
actual <- y_test
preds <- fit_test
rss <- sum((preds - actual) ^ 2)
tss <- sum((actual - mean(actual)) ^ 2)
rsq <- 1 - rss/tss
rsq # 0.772

# RMSE:
rmse(actual = y_test, predicted = fit_test) #42082.37
