#intall.packages("imageRy")

library(imageRy)
library(terra)
library(viridis)

im.list() #all the data inside the package

#import various raster thingies from sentinel images
cr <- colorRampPalette(c("#000","#f7f7f7")) (100)
noblue <- colorRampPalette(c("#ffff00","#fff")) (100)
b2 <- im.import("sentinel.dolomites.b2.tif")
b3 <- im.import("sentinel.dolomites.b3.tif")
b4 <- im.import("sentinel.dolomites.b4.tif")

plot(b2, col=cr)
plot(b3, col=cr)
plot(b4, col=cr)

#import NIR
b8 <- im.import("sentinel.dolomites.b8.tif")
plot(b8, col=cr)

par(mfrow= c(2,2))
plot(b2, col=cr)
plot(b3, col=cr)
plot(b4, col=cr)
plot(b8, col=cr)

#build your own function

multiframe <- function (x,y)
  {par(mfrow= c(x,y))}

multiframe(2,2)
plot(b2, col=cr)
plot(b3, col=cr)
plot(b4, col=cr)
plot(b8, col=cr)  #same result as before

dev.off

#stack
multiband <- c(b2, b3, b4, b8)
plot(multiband, col=cr)

dev.off
multiframe(1,2)
plot(b2,b3, xlab="b2-blue", ylab="b3-green", main= "blue vs green")


plot(b2,b8, xlab="b2-blue", ylab="b8-green", main= "blue vs NIR")
