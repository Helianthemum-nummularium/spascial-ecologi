#Let's build Graphs 
#run: install.packages("igraph")
library(igraph)

# let's build a fictitious food chain network

species <- c("algae", "zooplankton", "smolfish", "bigfish", "birbs")

predator <- c("zooplankton", "smolfish", "bigfish", "birbs", "birbs")
prey <- c("algae", "zooplankton","smolfish", "smolfish", "bigfish")

interactions <- data.frame(predator, prey)

G <- graph_from_data_frame(interactions, vertices=species, directed=T)

set.seed(42)
