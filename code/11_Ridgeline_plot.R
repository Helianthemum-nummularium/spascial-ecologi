library(terra)
library(imageRy)
library(ggplot2)
library(ggridges)
library(viridis)


im.list()

EN01 <- im.import("EN_01.png")
EN01 <- flip(EN01)
EN13 <- flip(im.import("EN_13.png"))

difEN = EN01[[1]] - EN13[[1]]

ndvi <- im.import("NDVI_2020")
plot(ndvi)

# im.ridgeline(ndvi, scale=1) doesn't work, conflicting names of the variables

names(ndvi) <- c("feb", "may", "aug", "nov") 
im.ridgeline(ndvi, scale=2)

#greenland ice sheet melting
gr <- im.import("greenland")

plot(gr)

difgr <- gr[[1]]-gr[[4]]
plot(difgr)

im.ridgeline(gr, scale=2)
