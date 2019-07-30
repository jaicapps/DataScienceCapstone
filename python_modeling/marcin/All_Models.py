# -*- coding: utf-8 -*-
"""
Created on Tue Jul 30 15:25:47 2019

@author: grzechu
"""

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

#Ridge Regression
from sklearn.linear_model import RidgeCV
from sklearn.datasets import load_boston
from sklearn.preprocessing import StandardScaler

######################################### Read the data ######################
############# Read transformed data (dummies scaled)
data = pd.read_csv("pluto5_stddum.csv")


######################## TARGET IS: ASSESSLAND #############################
data=data.drop(['bldgarea', 'numfloors', 'unitsres', 'unitstotal','bldgfront', 'bldgdepth', 
                'ext.1','proxcode.1', 'proxcode.2',
                'yearbuilt', 'yearalter','income'],axis=1)

X = data.drop(['assessland'], axis=1)
y = data['assessland']#.values.reshape(-1,1)

