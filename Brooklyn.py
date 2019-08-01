import pandas as pd

df= pd.read_csv("pluto6_fullstd.csv")
i = df[df['borocode.3']==0].index
df = df.drop(i)

df.to_csv("Brooklyn.csv", index = False)

df1 = pd.read_csv("pluto4.csv")
j = df1[df1['borocode']!=3].index
df1 = df1.drop(j)
df1.to_csv("Brooklyn_Merge.csv", index = False)