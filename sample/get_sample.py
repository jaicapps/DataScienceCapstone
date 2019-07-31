#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 25 13:51:39 2019

@author: mikaelapisanileal
"""

from proportion_sample import create_sample
import pandas as pd

df1 = pd.read_csv("../pluto6_fullstd.csv")
df2 = pd.read_csv("../pluto4.csv")
df = pd.concat([df1, df2["zipcode"]], axis=1, ignore_index=True)
X_train, X_test, y_train, y_test, predictors = create_sample(df, "assessland", 0.02, 0.005)

df = pd.DataFrame(X_train)
df.columns = predictors
df["assessland"] = pd.DataFrame(y_train)

#Save data
df.to_csv("pluto5_samplestd.csv", index=False)