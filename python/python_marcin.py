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
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import f_regression

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


# Call the function which gives you k best predictors
top_predictors_list=select_kbest_reg(df1, 'assessland', k=10)

### Use those predictors to build a tree
type(to_factors)
def a_tree:
    # X contains only predictors choosen by the function select_kbest_reg
    X = df1[top_predictors_list]
    # y only target variables
    y = df1['assessland']















feat=SelectKBest(f_regression, k=2).fit_transform(df1.drop('assessland', axis=1), df1['assessland'])
feat.scores_

#apply SelectKBest class to extract top 10 best features
bestfeatures = SelectKBest(score_func=chi2, k=10)
fit = bestfeatures.fit(X,y)
dfscores = pd.DataFrame(fit.scores_)
dfcolumns = pd.DataFrame(X.columns)
#concat two dataframes for better visualization 
featureScores = pd.concat([dfcolumns,dfscores],axis=1)
featureScores.columns = ['Specs','Score']  #naming the dataframe columns
print(featureScores.nlargest(20,'Score'))



from sklearn.feature_selection import SelectPercentile
from sklearn.feature_selection import f_regression
Selector_f = SelectPercentile(f_regression, percentile=25)
Selector_f.fit(X,y)
for n,s in zip(boston.feature_names,Selector_f.scores_):
 print ‘F-score: %3.2ft for feature %s ‘ % (s,n)