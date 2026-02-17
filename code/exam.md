
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
aois2<-st_as_sf(aois)

```

Getting client, collection and setting time range
```r
client<-GetOAuthClient("##-########-####-####-####-###########", "################################")
GetCollections()
sent2<-"sentinel-2-l2a"
GetQueryables(sent2,client=client)
#      collection           name description   type enum minimum maximum
#1 sentinel-2-l2a eo:cloud_cover Cloud Cover number            0     100
query<-SearchCatalog(
aoi=aois2,
collection=sent2,
from="2025-05-01",
to="2025-10-31",
filter="eo:cloud_cover<10",
client=client
)
days<-rev(query$acquisitionDate)

```


```r
df_script<-data.frame(
short_name="PP",
long_name="Penguin Poo",
platforms="Sentinel-2",
bands=I(list(c("B", "R"))),
formula="(R - B)"
)
cat(MakeEvalScript(df_script),sep = "\n", file = "penguin_poo.js")

lst_rast<-lapply(aois2,SearchCatalogByAOI,collection=sent2,time_range=tr,filter="eo:cloud_cover<10",client=client)

```
