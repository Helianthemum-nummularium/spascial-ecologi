
Installing and loading libraries
```r
install.packages("CDSE")
install.packages("terra")
install.packages("sf")

library(CDSE)
library(terra)
library(sf)
```

loading list of coordinates from directory. The coordinates are taken from the article
```r
colonies_article<-as.matrix(read.csv("pingwin.csv",sep=";"))
multipenguin<-st_multipoint(colonies_article)
multipenguin2<-st_sfc(multipenguin,crs=4326)

```


```r
multipenguin3<-vect(multipenguin2)
aois<-buffer(multipenguin3,10000)

```


```r



```
