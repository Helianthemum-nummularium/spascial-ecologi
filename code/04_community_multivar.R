#code for performing multivariate analyses for community ecology
#install "vegan" package
#book recommendation: numerical ecology
#upload "dune" dataset
library(vegan)

data(dune)
head(dune)

multivar<-decorana(dune)
multivar

#axis length
dca1 <- 3.7004 
dca2 <- 3.1166 
dca3 <- 1.30055 
dca4 <- 1.47888

total_l = sum(c(dca1, dca2, dca3, dca4))
#explained variability by axis
# Proportions
prop1 = dca1/total_l
prop2 = dca2/total_l
prop3 = dca3/total_l
prop4 = dca4/total_l

# Percentages
perc1 = prop1*100
perc2 = prop2*100
perc3 = prop3*100
perc4 = prop4*100

plot(multivar)
