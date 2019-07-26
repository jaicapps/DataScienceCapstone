# -*- coding: utf-8 -*-
"""
Created on Thu Jul 25 21:46:17 2019

@author: grzechu
"""

## Based on:
# https://towardsdatascience.com/feature-selection-techniques-in-machine-learning-with-python-f24e7da3f36e

#Load the data
import pandas as pd
import numpy as np


#Read the data
data = pd.read_csv("sample/sample_0.011.csv")
# drop also block and lot
data=data.drop(['lot','block'], axis=1)


#Scpecify what columns are factors
to_factors = ["cd","schooldist","council","zipcode","firecomp","policeprct",
               "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
               "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
               "healthcenterdistrict", "pfirm15_flag"]

#Iterate thru dataset and convert columns from "to_factors" into 
for i in to_factors: 
    data[i] = data[i].astype('category')
    print(i) 


##### Feature Selection #####
#### 1. f_regression using SelectKBest
# About the F-Test etc.: https://stats.stackexchange.com/questions/204141/difference-between-selecting-features-based-on-f-regression-and-based-on-r2

## Target variables is Assessland
df1 = data.drop(['assesstot'], axis=1)

## Convert all to dummies, AND DELETE factors which means we do k-1 variables
df_dummies = pd.get_dummies(df1[to_factors], drop_first=True)
#Drop old factors from the dataset (oryginal one, those not one-hot encoded)
df1.drop(to_factors, axis=1, inplace=True)
#Concat numeric variables wiht converted factors
df1 = pd.concat([df1, df_dummies], axis=1)

from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import f_regression
## Select the best k predictors from data
def select_kbest_reg(data_frame, target, k):
    """
    Selecting K-Best features regression
    :param data_frame: A pandas dataFrame with the training data
    :param target: target variable name in DataFrame
    :param k: desired number of features from the data
    :returns feature_scores: scores for each feature in the data as 
    pandas DataFrame
    """
    feat_selector = SelectKBest(f_regression, k=k)
    _ = feat_selector.fit(data_frame.drop(target, axis=1), data_frame[target])
    
    feat_scores = pd.DataFrame()
    feat_scores["F-Score"] = feat_selector.scores_
    feat_scores["P-Value"] = feat_selector.pvalues_
    feat_scores["Support"] = feat_selector.get_support()
    feat_scores["Attribute"] = data_frame.drop(target, axis=1).columns
    
    #top_predictors=select_kbest_reg(df1, 'assessland', 10)
    top_predictors_true=feat_scores.loc[feat_scores['Support']]
    #Convert column with predictors into list
    predictors_list=top_predictors_true['Attribute'].values.tolist()
    
    return predictors_list


## Run random Forest with k predictors choosen by previous function
## and calculate the rmse    
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error
from sklearn.metrics import mean_absolute_error
from math import sqrt
### Use those predictors to build a tree
def a_tree(df1, top_predictors_list):
    # X contains only predictors choosen by the function select_kbest_reg
    X = df1[top_predictors_list]
    # y only target variables
    y = df1['assessland']

    #Build a tree
    reg = RandomForestRegressor(
            n_estimators=100, 
            max_depth=100, 
            bootstrap=True, 
            random_state=123
            )
    reg.fit(X, y)
    
    
    # Calcualte evaluation metrics
    preds = reg.predict(X)
    rms = sqrt(mean_squared_error(y, preds))
    mae = mean_absolute_error(y, preds)

    return rms, mae

# max number of predictors you want:
k=10
for i in range(1, k+1):
    print("number of predictors",i)

    # Call the function which gives you k best predictors
    top_predictors_list=select_kbest_reg(df1, 'assessland', k=i)
    print(top_predictors_list)

    # Call the function to create a tree and give rmse
    print('Error:',a_tree(df1, top_predictors_list))


# Combined preds and actual values into one column
actual_pred = pd.DataFrame({"pred": preds})
actual_pred['actual'] = y 








