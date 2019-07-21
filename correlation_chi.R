####Chi-Square Test
source("libraries.R")
source("data_type_fun.R")
df <- read.csv("pluto3.csv")
df <- data_type(df)

col_var <- c("block","lot","cd","schooldist","council","zipcode","firecomp","policeprct",
             "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
             "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
             "healthcenterdistrict", "pfirm15_flag")

row_var <- col_var

counter <- 0
test2 <- data.frame()

for (j in col_var) {
  for(i in row_var) {
    chi_res <- chisq.test(df[,j], df[,i], simulate.p.value = TRUE)
    test2[i,j] <- paste(round(chi_res$statistic,3), chi_res$p.value, sep=", ")
    print(paste0("done ",i," ",j))
    print(counter <- counter+1)
  }
}

write_csv(test2, path = "correlation/factors_chi2.csv")

