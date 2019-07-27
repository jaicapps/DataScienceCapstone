#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 27 17:18:18 2019

@author: jaimiecapps
"""

###### PCA #######
# Feature Extraction with PCA
import numpy as np
import pandas as pd
from sklearn.decomposition import PCA
data = pd.read_csv("Documents/GitHub/Capstone/sample/sample_0.011.csv")
data=data.drop([#'xcoord','ycoord', #'income', # income comes when it is pluto3
                "cd","schooldist","council","firecomp","policeprct",
               "healtharea","sanitboro","sanitsub","zonedist1","spdist1","irrlotcode","sanitdistrict"], axis=1)

data=data.drop(['lot','block'], axis=1)


to_factors = ["zipcode","ltdheight","landuse",
               "ext","proxcode","lottype","borocode","edesignum", "pfirm15_flag"]

#Iterate thru dataset and convert columns from "to_factors" into 
for i in to_factors: 
    data[i] = data[i].astype('category')
    print(i) 
    
 
# load data
array = np.array(data)
data.columns
X = array[:,0:26]
Y = array[:,26]

# feature extraction
pca = PCA(n_components=3)
fit = pca.fit(array)

# summarize components
# print("Explained Variance: %s") % fit.explained_variance_ratio_
print(fit.components_)

############################ Incremental PCA ###############33
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA, IncrementalPCA

data = pd.DataFrame(data)
X2 = data.data
Y2 = data.target

n_components = 3
ipca = IncrementalPCA(n_components=n_components, batch_size=10)
X2_ipca = ipca.fit_transform(X2)

pca = PCA(n_components=n_components)
X2_pca = pca.fit_transform(X2)

colors = ['navy', 'turquoise', 'darkorange']

for X2_transformed, title in [(X2_ipca, "Incremental PCA"), (X2_pca, "PCA")]:
    plt.figure(figsize=(8, 8))
    for color, i, target_name in zip(colors, [0, 1, 2], data.target_names):
        plt.scatter(X2_transformed[y == i, 0], X2_transformed[y == i, 1],
                    color=color, lw=2, label=target_name)

    if "Incremental" in title:
        err = np.abs(np.abs(X2_pca) - np.abs(X2_ipca)).mean()
        plt.title(title + " of iris dataset\nMean absolute unsigned error "
                  "%.6f" % err)
    else:
        plt.title(title + " of iris dataset")
    plt.legend(loc="best", shadow=False, scatterpoints=1)
    plt.axis([0, 26, 0, 26])

plt.show()

