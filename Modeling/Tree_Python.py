import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
%matplotlib inline

#READ the dataset
dataset = pd.read_csv('pluto3.csv')

#Check DATATYPE of df
dataset.info()
#List of variables to convert to FACTOR
to_factors = ["block","lot","cd","schooldist","council","zipcode","firecomp","policeprct",
               "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
               "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
               "healthcenterdistrict", "pfirm15_flag"]
#Iterate thru dataset and convert columns from "to_factors" into 
for i in to_factors: 
    dataset[i] = dataset[i].astype('category')
    print(i) 

#Drop X and Y coordinates
dataset = dataset.drop('xcoord', axis=1)
dataset = dataset.drop('ycoord', axis=1)

#Convert into values
from sklearn.preprocessing import LabelEncoder
le = LabelEncoder()
convert_for_le =['firecomp' .....] #finish specifying what are numbers+factors
for i in to_factors: 
    dataset[i] = dataset[i].astype('category')
    print(i) 
dataset['firecomp'] = le.fit_transform(dataset['firecomp'].astype(str))


#dataset = dataset.drop(['firecomp','sanitsub'], axis=1)

#Divide the data
X = dataset.drop('assesstot', axis=1)
y = dataset['assesstot']

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=0)

#Training and making predictions
from sklearn.tree import DecisionTreeRegressor
regressor = DecisionTreeRegressor()
regressor.fit(X_train, y_train)
