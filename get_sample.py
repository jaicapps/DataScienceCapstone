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

#define categorical variables
df["borocode_block"] = df["borocode"].astype(str) + df["block"].astype(str)
cat_vars = ["borocode_block"]
predictors = ["healtharea", "income"]
target = ["assesstot"]
#drop assessland
df.drop('assessland', axis=1, inplace=True)
df.drop('borocode', axis=1, inplace=True)
df.drop('block', axis=1, inplace=True)

#transform to categorical variables, variables choosen to take proportion
df[cat_vars] = df[cat_vars].apply(lambda x:x.astype('category'))

#calculate proportions and remove the ones that has less than 2 in one class
a = df[['borocode_block']].groupby(["borocode_block"]).size()
to_remove = a[a<2]
a = a[a>1]
df = df.loc[df['borocode_block'].isin(a.index.values)]
df['borocode_block'] = df['borocode_block'].cat.remove_categories(to_remove.index.values)

#set seet
RANDOM_SEED = 101
#transform predictors and target to array
x = np.array(df[predictors])
y = np.array(df[target])
#get values for proportion variables
categorical_values = df.select_dtypes(include=['category'])

#choose 20% for training and 5% for test
#reference: https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html
X_train, X_test, y_train, y_test = train_test_split(x, y, train_size=0.2, 
                                                    test_size=0.05, 
                                                    random_state = RANDOM_SEED, 
                                                    stratify=categorical_values)

total = df.shape[0]
#check proportions -- substruction should be near 0
borocode_prop = df[['block']].groupby(["block"]).size()/total
borocode_prop_test = pd.DataFrame(X_test).groupby([0]).size()/(total*0.05)

