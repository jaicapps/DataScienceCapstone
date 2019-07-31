# -*- coding: utf-8 -*-
"""
Created on Tue Jul 30 15:25:47 2019

@author: grzechu
"""

######################################### Imports ######################

# Basic 
import pandas as pd
import numpy as np

#Modeling/evaluatiing/Plots
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
from math import sqrt
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick


#Ridge Regression
from sklearn.linear_model import RidgeCV
from sklearn.linear_model import Ridge

#Lasso
from sklearn.linear_model import LassoCV
from yellowbrick.regressor import AlphaSelection
from sklearn.linear_model import Lasso


######################################### Read the data ######################
############# Read transformed data (dummies scaled)
data = pd.read_csv("pluto5_stddum.csv")


######################## TARGET IS: ASSESSLAND #############################
data=data.drop(['bldgarea', 'numfloors', 'unitsres', 'unitstotal','bldgfront', 'bldgdepth', 
                'ext.1','proxcode.1', 'proxcode.2',
                'yearbuilt', 'yearalter','income'],axis=1)


#############################################################################
############################### MODELING ######################################
#############################################################################


################################### RIDGE REGRESSION #########################
X = data.drop(['assessland'], axis=1)
y = data['assessland'].values.reshape(-1,1)

####### a) looking for best parameters
''' Run it only to find the best alpha
#Set a ranges for alphas
alphas_range=np.arange(1, 10000, 10)
# Crossvalidate for the best alphas
regr_cv = RidgeCV(alphas=alphas_range)
# Fit the linear regression
model_cv = regr_cv.fit(X, y)
model_cv.alpha_ # best parameter shows up to be 81'''

####### b) Implement Ridge Regression
X_train, X_test , y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1)

ridge = Ridge(alpha = 81) # this parameter is choosen by RidgeCV
ridge.fit(X_train, y_train) # Fit a ridge regression on the training data
coefs_ridge = pd.DataFrame(ridge.coef_.T, index =[X.columns]) # Print coefficients
coefs_ridge = coefs_ridge.rename(columns={0:'coef_value'})       

# TRAIN SET
pred_train = ridge.predict(X_train) # Use this model to predict the train data
# Calculate RMSE train
print("RMSE for Train:",sqrt(mean_squared_error(y_train, pred_train))) #RMSE
print("R^2 for Train:",ridge.score(X_train, y_train)) #R2

# TEST SET
pred_test = ridge.predict(X_test)
#RMSE test
print("RMSE for Test:",sqrt(mean_squared_error(y_test, pred_test))) #RMSE
print("R^2 for Test:",ridge.score(X_test, y_test)) #R2

##### c) plots
#i) lines plot
fig, ax = plt.subplots()
ax.plot(y_test, color = 'blue')
ax.plot(pred_test, color = 'red')
ax.legend(['Real', 'Predicted'])
fig.savefig('real_vs_pred_nn.png')
plt.show()

#ii) histogram of difference for TEST
y_test = pd.DataFrame(y_test)
y_test['new']=y_test.index
pred_reg = pd.DataFrame(pred_test)
pred_reg.index=y_test['new'].values
y_test = y_test.drop('new',axis=1)
pred_reg = pred_reg.rename(columns={0:'predicted'})
x =pd.DataFrame(y_test[0]-pred_reg['predicted'])
x = x.rename(columns={0:'difference'})
done = pd.concat([x,y_test,pred_reg],axis=1)

p = x['difference'].values
type(p)
plt.hist(p, bins='auto', range=(-75000, 75000))

#iii) histogram of difference for TRAIN
y_train = pd.DataFrame(y_train)
y_train['new']=y_train.index
pred_reg = pd.DataFrame(pred_train)
pred_reg.index=y_train['new'].values
y_train = y_train.drop('new',axis=1)
pred_reg = pred_reg.rename(columns={0:'predicted'})
x =pd.DataFrame(y_train[0]-pred_reg['predicted'])
x = x.rename(columns={0:'difference'})
done = pd.concat([x,y_train,pred_reg],axis=1)

p = x['difference'].values
type(p)
plt.hist(p, bins='auto', range=(-75000, 75000))

## SUMMARY: 
print("RMSE for Train:",sqrt(mean_squared_error(y_train, pred_train))) #RMSE
print("R^2 for Train:",ridge.score(X_train, y_train)) #R2
print("RMSE for Test:",sqrt(mean_squared_error(y_test, pred_test))) #RMSE
print("R^2 for Test:",ridge.score(X_test, y_test)) #R2


#c) Show the biggest coeficient (Top 10)
largest=coefs_ridge.nlargest(5,'coef_value')
smallest=coefs_ridge.nsmallest(5,'coef_value')
both=pd.concat([largest,smallest], axis=0)
# make a bar up and down
baseline = 1
plt.bar(range(len(both['coef_value'])),[x-baseline for x in both['coef_value']])
plt.xticks(np.arange(10), (both.index.values))
plt.xticks(rotation=90)
plt.show()

################################### LASSO ####################################

##Finding the best alpha
# reference: https://www.scikit-yb.org/en/latest/api/regressor/alphas.html
# Create a list of alphas to cross-validate against
alphas=np.arange(1, 100, 1) #range for alpha
# Instantiate the linear model and visualizer
model = LassoCV(alphas=alphas)
visualizer = AlphaSelection(model)
visualizer.fit(X, y)
g = visualizer.poof()
