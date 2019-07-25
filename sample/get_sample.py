#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 25 13:51:39 2019

@author: mikaelapisanileal
"""

from proportion_sample import create_sample
import pandas as pd

df = pd.read_csv("../pluto2.csv")
df_assestot = pd.DataFrame.copy(df)
X_train, X_test, y_train, y_test, predictors = create_sample(df, "assessland", 0.1, 0.025)

df1 = pd.DataFrame(X_train)
df1.columns = predictors
df1["assessland"] = pd.DataFrame(y_train)

df2 = pd.DataFrame(X_test)
df2.columns = predictors
df2["assessland"] = pd.DataFrame(y_test)

df = pd.concat([df1, df2])
df.to_csv("sample.csv", index=False)


cat_vars = ['cd', 'schooldist', 'council', 'zipcode', 'firecomp',
       'policeprct', 'healtharea', 'sanitboro', 'sanitsub', 'zonedist1',
       'spdist1', 'ltdheight', 'landuse', 'ext', 'proxcode', 'irrlotcode', 'lottype',
       'residfar', 'borocode', 'edesignum', 'sanitdistrict', 'healthcenterdistrict', 
       'pfirm15_flag']

df[cat_vars] = df[cat_vars].apply(lambda x:x.astype('category'))
df.drop(['xcoord', 'ycoord'], axis=1, inplace=True)

sapply(df[,sapply(df,is.factor)], nlevels)