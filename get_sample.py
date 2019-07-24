#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 23 19:09:02 2019

@author: mikaelapisanileal
"""
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split

#read csv
df = pd.read_csv("pluto3.csv")
print(df.columns)

#to try first keep few cols
df = df[["borocode", "income","assesstot"]]

#define categorical variables
cat_vars = ["borocode"]

#transform to categorical variables
df[cat_vars] = df[cat_vars].apply(lambda x:x.astype('category'))
df.describe

total = df.shape[0]

borocode_prop = df.groupby(["borocode"]).size()/total

RANDOM_SEED = 101
x = np.array(df[["borocode", "income"]])
y = np.array(df[["assesstot"]])
#TODO: choose train_size and test_size
categorical_values = df.select_dtypes(include=['category'])

#https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html
X_train, X_test, y_train, y_test = train_test_split(x, y, train_size=0.2, 
                                                    test_size=0.05, 
                                                    random_state = RANDOM_SEED, 
                                                    stratify=categorical_values)

borocode_prop_test = pd.DataFrame(X_test).groupby([0]).size()/(total*0.05)
#option: https://www.kdnuggets.com/2019/05/sample-huge-dataset-machine-learning.html
borocode_prop - borocode_prop_test