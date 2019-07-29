#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 29 13:42:35 2019

@author: jaimiecapps
"""


from sklearn.decomposition import PCA


X = np.array(data)
pca = PCA(n_components=2)
pca.fit(X)  
print(pca.explained_variance_ratio_)  # [0.98286589 0.00952402]
print(pca.singular_values_) # [1442573.54358136  142004.09482145]


from sklearn.metrics import mean_squared_error
from math import sqrt
from sklearn.cross_validation import train_test_split
from sklearn.linear_model import LinearRegression

data=pd.read_csv('documents/Github/Capstone/sample/sample_0.011.csv')
data.head()
#x=data.iloc[:,2:3].values
#y=data.iloc[:,3:4].values

# split data into test or training set
X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.20, random_state=42)

# simple linear regression to training set
regressor=LinearRegression()
regressor.fit(x_train,y_train)

# predict result
y_pred=regressor.predict(x_test)

# see relationship between training data values
plt.scatter(x_train,y_train,c='red')
plt.show()

#to see the relationship between the predicted 
# values using scattered graph
plt.plot(x_test,y_pred)   
plt.scatter(x_test,y_test,c='red')
plt.xlabel(' ')
plt.ylabel(' ')

#combined rmse value
rss=((y_test-y_pred)**2).sum()
mse=np.mean((y_test-y_pred)**2)
print("Final rmse value is =",np.sqrt(np.mean((y_test-y_pred)**2)))
