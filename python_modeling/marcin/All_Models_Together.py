# -*- coding: utf-8 -*-
"""
Created on Tue Jul 30 13:29:44 2019

@author: grzechu
"""

############################# IMPORTS ################################

import pandas as pd
import numpy as np

from sklearn.preprocessing import LabelEncoder

from sklearn.model_selection import cross_val_score
from sklearn.linear_model import LinearRegression

from sklearn.model_selection import GridSearchCV
from sklearn.linear_model import Ridge

from sklearn.linear_model import Lasso

from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
from math import sqrt

############################# DATA READING ################################

#Read data
data = pd.read_csv("sample/sample_0.011.csv")
# drop block and lot, we don't use it
data=data.drop(['lot','block'], axis=1)
#Scpecify what columns are factors
to_factors = ["cd","schooldist","council","zipcode","policeprct","firecomp",
               "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
               "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
               "healthcenterdistrict", "pfirm15_flag"]

#Converte to factors
for i in to_factors: 
    data[i] = data[i].astype('category')
    print(i)    
    
########################### DUMMIE/ ONE-HOT ENCODING #######################

## Convert all to dummies, AND DELETE factors which means we do k-1 variables
df_dummies = pd.get_dummies(data[to_factors], drop_first=True)
#Drop old factors from the dataset (oryginal one, those not one-hot encoded)
df1=data.drop(to_factors, axis=1)
#Concat numeric variables wiht converted factors
df1 = pd.concat([df1, df_dummies], axis=1)

######################## TARGET IS: ASSESSLAND #############################
df_assessland = data.drop(['assesstot'], axis=1) # drop assesstot
#Drop all building info
df_assessland=df_assessland.drop(['bldgarea', 'numfloors', 'unitsres', 'unitstotal','bldgfront', 'bldgdepth', 'ext',
'proxcode', 'yearbuilt', 'yearalter','income'],axis=1)