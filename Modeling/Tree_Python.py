import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
%matplotlib inline

#Read the dataset
dataset = pd.read_csv('pluto3.csv')

dataset = dataset.drop('xcoord', axis=1)
dataset = dataset.drop('ycoord', axis=1)

y = dataset['Petrol_Consumption']