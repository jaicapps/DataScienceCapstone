#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 25 13:51:39 2019

@author: mikaelapisanileal
"""

from proportion_sample import create_sample
import pandas as pd

df = pd.read_csv("../pluto2.csv")
X_train, X_test, y_train, y_test, predictors = create_sample(df, "assessland", 0.011, 0.00075)

df = pd.DataFrame(X_train)
df.columns = predictors
df["assessland"] = pd.DataFrame(y_train)

#Drop X and Y
df.drop(['xcoord', 'ycoord'], axis=1, inplace=True)

#Save data
df.to_csv("sample_0.011.csv", index=False)
