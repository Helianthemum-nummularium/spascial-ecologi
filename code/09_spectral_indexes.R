library(terra)
library(imageRy)

im.list
mg92 <- im.import("matogrosso_l5_1992219_lrg.jpg") #band1=NIR, 2=R, 3=G
im.plotRGB(mg92, r=1,g=2,b=3)
mg06 <- im.import("matogrosso_ast_2006209_lrg.jpg") 
im.plotRGB(mg06, r=1,g=2,b=3)

#let's build a spectral index
#DVI = NIR-Red 

dvi92 <- mg92[[1]]-mg92[[2]]
dvi06 <- mg06[[1]]-mg06[[2]]



par(mfrow=c(1,2))
plot(dvi92)
plot(dvi06)

#NDVI (DVI/(NIR+RED))

ndvi92 <- dvi92/(mg92[[1]]+mg92[[2]])
ndvi06 <- im.ndvi(mg06,1,2)
    
