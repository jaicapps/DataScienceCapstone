####Chi-Square Test
df <- read.csv("pluto2.csv")

col_var <- c("schooldist","council","zipcode","firecomp",
                   "policeprct","healtharea","sanitboro","sanitsub","zonedist1","spdist1",
                   "irrlotcode","borocode","sanitdistrict","healthcenterdistrict","pfirm15_flag")

row_var <- c("schooldist","council","zipcode","firecomp",
             "policeprct","healtharea","sanitboro","sanitsub","zonedist1","spdist1",
             "irrlotcode","borocode","sanitdistrict","healthcenterdistrict","pfirm15_flag")


#Make for df
counter <- 0
test <- data.frame(matrix(vector(), length(row_var), length(col_var),dimnames=list(c())),stringsAsFactors=F)

for (j in col_var) {
  for(i in row_var) {
    
    tab <- table(as.factor(df[,j]), as.factor(df[,i]))
    chi_res <- chisq.test(tab,simulate.p.value = TRUE)
    
    res <- chi_res$statistic
    test[i,j] <- res
    print(paste0("done ",i," ",j))
    print(counter <- counter+1)
  }
}



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

