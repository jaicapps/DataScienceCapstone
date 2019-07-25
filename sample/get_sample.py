#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 25 13:51:39 2019

@author: mikaelapisanileal
"""

from proportion_sample import create_sample
import pandas as pd

df = pd.read_csv("../pluto2.csv")
X_train, X_test, y_train, y_test, predictors = create_sample(df, "assessland", 0.0015, 0.00075)

df = pd.DataFrame(X_train)
df.columns = predictors
df["assessland"] = pd.DataFrame(y_train)


cat_vars = ['cd', 'schooldist', 'council', 'zipcode', 'firecomp',
       'policeprct', 'healtharea', 'sanitboro', 'sanitsub', 'zonedist1',
       'spdist1', 'ltdheight', 'landuse', 'ext', 'proxcode', 'irrlotcode', 'lottype',
       'residfar', 'borocode', 'edesignum', 'sanitdistrict', 'healthcenterdistrict', 
       'pfirm15_flag']

df[cat_vars] = df[cat_vars].apply(lambda x:x.astype('category'))
df.drop(['xcoord', 'ycoord'], axis=1, inplace=True)

df.to_csv("sample.csv", index=False)