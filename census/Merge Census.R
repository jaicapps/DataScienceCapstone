#Read Libraries
library(readr)
library(readxl)
library(dplyr)

pluto <- read.csv("pluto_18v2_1.csv")
income <- read.csv("census/census_income.csv")
age_sex <- read.csv("census/census_age_sex.csv")

families <- select(income, "GEO.id2", "HC02_EST_VC01", "HC02_EST_VC15", "HC02_EST_VC05", "HC02_EST_VC08", "HC02_EST_VC11", "HC04_EST_VC01", "HC04_EST_VC15", "HC04_EST_VC05", "HC04_EST_VC08", "HC04_EST_VC11")
colnames(families) <- c("zipcode", "families", "mean_income_fam", "fam_2500_34999", "fam_75000_99999", "fam_200000", "non_familiy", "mean_income_non", "non_2500_3499", "non_75000_99999", "non_200000")

cen_age_sex <- select(age_sex, "GEO.id2", "HC02_EST_VC01", "HC03_EST_VC01")
colnames(cen_age_sex) <- c("zipcode", "male_population", "female_population")

data <- merge(pluto, families, by="zipcode", all = FALSE)
data <- merge(data, cen_age_sex, by="zipcode", all = FALSE)

write_csv(data, path = "census/pluto3.csv")






