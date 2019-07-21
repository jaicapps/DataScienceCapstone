####Chi-Square Test
source("libraries.R")
source("data_type_fun.R")
df <- read.csv("pluto2.csv")
df <- data_type(df)

col_var <- c("cd","schooldist","council","zipcode","firecomp","policeprct",
             "healtharea","sanitboro","sanitsub","zonedist1","spdist1","ltdheight","landuse",
             "ext","proxcode","irrlotcode","lottype","borocode","edesignum","sanitdistrict",
             "healthcenterdistrict", "pfirm15_flag","block","lot")

row_var <- col_var

#Make for df
counter <- 0
#test <- data.frame(matrix(vector(), length(row_var), length(col_var),dimnames=list(c())),stringsAsFactors=F)
test2 <- data.frame()

for (j in col_var) {
  for(i in row_var) {
    
    chi_res <- chisq.test(df[,j], df[,i], simulate.p.value = TRUE)
    
    res <- chi_res$statistic
    test2[i,j] <- res
    print(paste0("done ",i," ",j))
    print(counter <- counter+1)
  }
}

write_csv(test2, path = "correlation/factors_chi2.csv")

# # Done in matrix
# counter <- 0
# x <- matrix(0, nrow = length(col_var), ncol = length(col_var))
# for (j in col_var) {
#   for(i in row_var) {
#     
#     tab <- table(as.factor(df[,j]), as.factor(df[,i]))
#     chi_res <- chisq.test(tab,simulate.p.value = TRUE)
#     res <- list(chi_res$statistic, chi_res$p.value)
#     x <- append(x, res)
#     print(paste0("done ",i," ",j))
#     print(counter <- counter+1)
#   }
# }

