#spatial variability from remote sensing data

library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
library(patchwork)

im.list()

sent <- im.import("sentinel.png")
sent

plot(sent)
im.plotRGB(sent, r=1, g=2, b=3)  #yields same result???
im.plotRGB(sent, r=2, g=1, b=3) #NIR is green

#calculate standard deviation

focal(sent[[1]], fun="mean") #example
sentsd3 <- focal(sent[[1]], w=3, fun="sd")

p1 <- im.ggplot(sent[[1]])
p2 <- im.ggplot(meansent)
p3 <- im.ggplot(sentsd3)
p4 <- im.ggplot(sent)

p1+p2+p3+p4

sd5 <- focal(sent[[1]], w=5, fun="sd")
p5<- im.ggplot(sd5)

p3+p5
