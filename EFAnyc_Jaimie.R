# EFA --> NYC
df <- read.csv("~/Desktop/plutostuff/pluto3.csv")

# for variables (numbldgs, numfloors,	unitsres,	unitstotal)
df1 <- df[, 18:21]
df.fa = factanal(df1, factors = 1) 
# unitsres & unitstotal have strongest relationship to Factor 1 (>0.8)
# uniqueness is highest with numbldgs & numfloors
# Factor 1 can be latent perception of...


# for variables (landuse, lotarea, bldgarea)
df2 <- df[, 15:17]
df2.fa = factanal(df2, factors = 1)
# bldgarea has stronges relationship to Factor 1 (>0.8)
# uniqueness is highest with landuse & lotarea
# Factor 1 can be latent perception of...


# for variables (assestot, borocode & income)
df3 <- df[, c(31, 36, 44)]
df3.fa = factanal(df3, factors = 1)
# borocode has stronges relationship to Factor 1 but is not significant
# uniqueness is highest with all variables
# Factor 1 can be latent perception of...


# for variables (zipcode, assestot, borocode & income)
df4 <- df[, c(1, 31, 36, 44)]
df4.fa = factanal(df4, factors = 1)
# borocode has stronges relationship to Factor 1 but is not significant
# uniqueness is highest with all variables
# Factor 1 can be latent perception of...


# for variables (assessland,	assesstot,	yearbuilt, borocode)
df5 <- df[, c(30:32, 36)]
df5.fa = factanal(df5, factors = 1)
# assessland and assesstot has stronges relationship to Factor 1 (but is not significant (>0.85)
# uniqueness is highest with yearbuilt & borocode
# Factor 1 can be latent perception of...


# for variables (ltdheight,	landuse,	lotarea,	bldgarea,	numbldgs,	numfloors,	unitsres,	unitstotal,	lotfront,	lotdepth,	bldgfront,	bldgdepth)
df6 <- df[, 14:25]
df6.fa = factanal(df6, factors = 7)
print(df6.fa$loadings, cut = 0.35)
# Factor 1: unitsres & unitstot
# Factor 2: bldgfront
# Factor 3: lotdepth
# Factor 4: landuse
# Factor 5: ltdheight
# Factor 6: bldgarea (but not significant)
# Factor 7: numfloors (but not significant)
# uniqueness is highest with numbldgs


# for variables (zipcode	block	lot	cd	schooldist	council	firecomp	policeprct	healtharea	sanitboro)
df7 <- df[, c(1:6,8:10)]
df7.fa = factanal(df7, factors = 4)
print(df7.fa$loadings, cut = 0.35)
# Factor 1: policeprct & schooldist & sanitboro
# Factor 2: block & cd
# Factor 3: council & healtharea
# Factor 4: zipcode
# uniqueness is highest with lot (by pretty large margin)


# for variables (lottype, borocode, income)
df8 <- df[, c(29, 36, 44)]
df8.fa = factanal(df8, factors = 1) 
# uniqueness is highest with all variables



# RMSE measures the discrepancy between the original correlation matrix and the EFA approximated correlation matrix.

# e.loading = df.fa$loadings[,c( , )]
# corHat = e.loading %*% t(e.loading) + diag(df.fa$uniquenesses)
# corr = cor(df)
# rmse = sqrt(mean(corHat-corr)^2)

