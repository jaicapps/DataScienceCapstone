import pandas as pd
import numpy as np

data = pd.read_csv("pluto3.csv")

numeric =  ["lotarea", "bldgarea","numbldgs","numfloors","unitsres","unitstotal","lotfront",
            "lotdepth","bldgfront","bldgdepth","yearbuilt",
            "residfar","commfar","facilfar","yearalter"]

# Deleting all outliers that are three standard deviations from the mean for at least one of the numeric variables:
from scipy import stats
data=data[(np.abs(stats.zscore(data[numeric])) < 3).all(axis=1)]

data.to_csv("pluto4.csv", index = False)