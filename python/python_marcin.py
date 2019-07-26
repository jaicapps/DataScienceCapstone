# -*- coding: utf-8 -*-
"""
Created on Thu Jul 25 21:46:17 2019

@author: grzechu
"""

## Based on:
# https://towardsdatascience.com/feature-selection-techniques-in-machine-learning-with-python-f24e7da3f36e

import pandas as pd
import numpy as np
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2

data = pd.read_csv("sample/sample_0.011.csv")


#Factors
to_factors = ["cd","schooldist","council","zipcode","firecomp","policeprct",
               "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
               "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
               "healthcenterdistrict", "pfirm15_flag"]

#Iterate thru dataset and convert columns from "to_factors" into 
for i in to_factors: 
    data[i] = data[i].astype('category')
    print(i) 


#### 1. ONLY NUMERIC VARIABLES:
## Target variables is Assessland
df1 = data.drop(to_factors, axis=1) # drop all factors
df1 = df1.drop(['lot','block','assesstot'], axis=1) # drop also block and lot



X = df1.iloc[:,0:14]  #independent columns
y = df1.iloc[:,15]    #target column i.e price range

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