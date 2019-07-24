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
df = df[["block", "healtharea", "income","assesstot"]]

#define categorical variables
cat_vars = ["block"]
predictors = ["block", "healtharea", "income"]
target = ["assesstot"]

#transform to categorical variables
df[cat_vars] = df[cat_vars].apply(lambda x:x.astype('category'))

#calculate proportions
a = df[['block']].groupby(["block"]).size()
to_remove = a[a<2]
a = a[a>1]
df = df.loc[df['block'].isin(a.index.values)]
df['block'] = df['block'].cat.remove_categories(to_remove.index.values)

#drop rows that has only 1 

#set seet
RANDOM_SEED = 101
#transform to array
x = np.array(df[predictors])
y = np.array(df[target])
#get only categorical values
categorical_values = df.select_dtypes(include=['category'])

#TODO: choose train_size and test_size. For now choose 20% for training and 5% for test
#reference: https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html
X_train, X_test, y_train, y_test = train_test_split(x, y, train_size=0.2, 
                                                    test_size=0.05, 
                                                    random_state = RANDOM_SEED, 
                                                    stratify=categorical_values)

total = df.shape[0]
#check proportions -- substruction should be near 0
borocode_prop = df[['block']].groupby(["block"]).size()/total
borocode_prop_test = pd.DataFrame(X_test).groupby([0]).size()/(total*0.05)

