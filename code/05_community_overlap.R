#temporal overlap
#install overlap package

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

#species list
par(mfrow=c(3,3))
species_list <- unique(kerinci$Sps)

for (sps in species_list) {
  species_data <- kerinci[kerinci$Sps == sps,-3]
    # Create a density plot for the 'circ' variable of the current species
  plot(density(species_data$azimuth), 
       main = paste("Density Plot of Circumference for", sps), 
       xlab = "Circumference")
}
