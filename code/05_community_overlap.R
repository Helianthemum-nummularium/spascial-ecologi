#temporal overlap
#intall overlap package

library(overlap)
data(kerinci)

#convert time to radiant sun azimuth kinda

sunazimuth <- kerinci$Time * 2 * pi
kerinci$azimuth <- kerinci$Time * 2 * pi
tiger <- kerinci[kerinci$Sps=="tiger",-3]
tigertime <- tiger$azimuth

densityPlot(tigertime)

# sac ma caque

macaque <- kerinci[kerinci$Sps=="macaque",-3]
macaquetime <- macaque$azimuth

densityPlot(macaquetime)
overlapPlot( macaquetime, tigertime)
