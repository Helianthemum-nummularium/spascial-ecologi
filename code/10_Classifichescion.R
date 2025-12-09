#(install if needed)
library(terra)
library(imageRy)
library(ggplot2)
library(patchwork)

im.list()
mg92 <- im.import("matogrosso_l5_1992219_lrg.jpg") #band1=NIR, 2=R, 3=G
plot(mg92)

mg06 <- im.import("matogrosso_ast_2006209_lrg.jpg") 
plot(mg06)


sun <- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

sol <- im.classify(sun, 3) #unsupervised classification

mg92c <- im.classify(mg92, 2)
tot92 <- ncell(mg92c)
f92 <- freq(mg92c)
perc92 <- 100*(f92/tot92)
perc92

perc06 <- (freq(mg06c)/ncell(mg06c))*100

forest92<-perc92[2,3]
humanModified92<-perc92[1,3]

forest06<-perc06[2,3]
humanModified06<-perc06[1,3]

class<- c("forest","human-modified")
percentage1992 <- c(forest92, humanModified92)
percentage2006 <- c(forest06, humanModified06)
tabout<- data.frame(class, percentage1992, percentage2006)

geom_bar(stat="identity", fill="#fff")
p1 <- ggplot(tabout, aes(x=class, y=percentage1992, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
p2 <- ggplot(tabout, aes(x=class, y=percentage2006, color=class)) + geom_bar(stat="identity", fill="#ab46fc") + ylim(c(0,100))

p1+p2
