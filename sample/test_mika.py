#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 25 19:20:04 2019

@author: mikaelapisanileal
"""

# Feature Extraction with Univariate Statistical Tests (Chi-squared for classification)
import pandas as pd
import numpy
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2

# load data
df = pd.read_csv('sample_0.011.csv')
df.drop(['block', 'lot'], axis=1, inplace=True)

categorical_vars = ['cd', 'schooldist', 'council', 'zipcode', 'firecomp',
       'policeprct', 'healtharea', 'sanitboro', 'sanitsub', 'zonedist1',
       'spdist1', 'ltdheight', 'landuse',  'ext', 'proxcode', 'irrlotcode', 'lottype',
       'borocode','edesignum', 'sanitdistrict', 'healthcenterdistrict', 'pfirm15_flag']

df[categorical_vars] = df[categorical_vars].apply(lambda x:x.astype('category'))
df_dummies = pd.get_dummies(df[categorical_vars], drop_first=False) #keep all dummies to evaluate importance, for the prediction should say drop_first=True
df.drop(categorical_vars, axis=1, inplace=True)
df = pd.concat([df, df_dummies], axis=1)

X = df[df.columns]
X.drop('assesstot', axis=1, inplace=True)
predictors = X.columns
X = X.values
Y = df['assesstot'].values

# feature extraction
test = SelectKBest(score_func=chi2, k=60)
fit = test.fit(X, Y)
# summarize scores
numpy.set_printoptions(precision=3)
scores = fit.scores_
scores_df = pd.DataFrame(scores, index=predictors, columns=['scores'])
features = fit.transform(X)

scores_df = scores_df.assign(support = fit.get_support())
scores_df.to_csv('scores.csv', index=True)