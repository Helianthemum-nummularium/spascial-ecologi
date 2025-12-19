#multivariate analysis of RS data

library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
library(patchwork)


sent <- im.import("sentinel.png")

q1 <- im.ggplot(sent[[1]])
q2 <- im.ggplot(sent[[2]])
q3 <- im.ggplot(sent[[3]])

names(sent) <- c(NIR, R, G)
pairs(sent)
sentpc <- im.pca(sent)

pc1sd3 <- focal(sentpc[[1]], w=3 , fun="sd")

sentsd3 <- focal(sent[[1]], w=3 , fun="sd")

p3 <- im.ggplot(sentsd3) 
q4 <- im.ggplot(pc1sd3)

p3+q4
