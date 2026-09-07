
Installing libraries (optional)
```r
install.packages("CDSE")
install.packages("terra")
install.packages("sf")
install.packages("magick")
```

Loading libraries
```r
library(CDSE)
library(terra)
library(sf)
library(magick)
```

Setting working directory
```r
setwd("C:/Users/Elia/Desktop/UniBo/ERRE/Specology")
getwd()
##[1] "C:/Users/Elia/Desktop/UniBo/ERRE/Specology"

```

Now we set up all the required objects and variables to use as parameters with the package CDSE:
* Vector file of our lake of interest, from this we calculate its bounding box;
* Creating a client to use the API;
* Retrieving the exact name of the sentinel 2 collection that we're going to use;
* Creating time intervals for uor period of interest.

```r
##load lago maggiore vector file and calculate bbox
lagmag_as_sf<-st_read("lago_maggiore.geojson")
bbox<-st_bbox(lagmag_as_sf)

##get client
client<-GetOAuthClient(
id="##-########-####-####-####-###########",
secret="################################"
)
##
GetCollections()
##                       id                   title
## 1         sentinel-2-l1c          Sentinel 2 L1C
## 2     sentinel-3-olci-l2      Sentinel 3 OLCI L2
## 3          landsat-ot-l1 Landsat 8-9 OLI-TIRS L1
## 4        sentinel-3-olci         Sentinel 3 OLCI
## 5       sentinel-3-slstr        Sentinel 3 SLSTR
## 6    sentinel-3-slstr-l2     Sentinel 3 SLSTR L2
## 7  sentinel-3-synergy-l2   Sentinel 3 Synergy L2
## 8         sentinel-1-grd          Sentinel 1 GRD
## 9         sentinel-2-l2a          Sentinel 2 L2A
## 10        sentinel-5p-l2    Sentinel 5 Precursor
## ...
##store name into a variable for ease of use
sent2<-"sentinel-2-l2a"

## create intervals
intervals<-lapply(1:10,function(i){
    start<-as.Date("2026-06-01","%Y-%m-%d")+6*(i-1)
    end<-as.Date(format(start + 2, "%Y-%m-%d"))
	c(start,end)
})
```
Now we are going to build a query. The result of our query is going to be a list of 10 data frames (one for each time interval), each data frame containing a set of sentinel-2 observations with info on cloud cover. From each data frame we are going to select the observation with the least cloud cover. The result is still going to be a list of data frame, each data frame now having only one observation. After we are going to turn this into a single data frame.
```r
## build query
query <- lapply(intervals, SearchCatalogByTimerange, bbox = bbox,
collection = sent2, with_geometry = FALSE, client = client)

## selecting from each dataframe the least cloudy image
least_cloudy <- lapply(query, function(df) {
    df[which.min(df$tileCloudCover), ]
})

## turning the list of data frames into a single data frame
least_cloudy <- do.call(rbind, least_cloudy)
```


The next step is to actually download the rasters using the acquisition dates of the least cloudy images as parameter. As we do this operation we can also apply an evaluation script to the images we download to obtain our desired final product right away. Band can be combined to derive any kind of index. In this case, we are going to use a script provided by  (https://custom-scripts.sentinel-hub.com/custom-scripts/sentinel-2/ulyssys_water_quality_viewer/). The script in question, Ulyssys Water Quality Viewer (UWQV), is a custom script to visualize the chlorophyll and sediment conditions of water bodies on both Sentinel-2 and Sentinel-3 images. According to the website "UWQV is just a visualization, not a quantitative map."
<img width="1120" height="743" alt="palette" src="https://github.com/user-attachments/assets/4fc691b0-8198-4065-ba4a-9ca0a7dbee20" />

```r
days<-least_cloudy$acquisitionDate
##downloading the rasters
lstRast <- lapply(days, GetImageByTimerange, bbox = bbox, collection = sent2,
                  script ="script.min.js", file = NULL, format = "image/tiff", mosaicking_order = "mostRecent",resolution = 25, buffer = 0, mask = TRUE, client = client)


```
The output of the previous operation is a list of SpatRaster objects. Now we will name each raster with its acquisition date as name and plot them to visualize a preliminary result.
```r
names(lstRast) <- as.character(days)	

par(mfrow=c(2,5))
sapply(seq_along(days), FUN = function(i) {
     ras <- lstRast[[i]]
     terra::plot(ras)
 })
```

<img width="1651" height="1404" alt="Rplot01" src="https://github.com/user-attachments/assets/3bac3efc-7447-48cf-b8df-849fc8afb2d2" />

## Creating animated gif
##### Now we are going to work with the library magick to create an animated gif using the 10 rasters as frames.

Setting variables to use for sizing legend and image
```r

image_w<-ncol(lstRast[[1]])
image_h<-nrow(lstRast[[1]])
legend_width<-round(ncol(lstRast[[1]])/2,0)
```

Storing the rasters into temporary png files and annotating the acquisition date on top of each one, then storing everything into a list
```r
maps <- lapply(seq_along(lstRast), function(i) {

  f <- tempfile(fileext = ".png")

  png(f, width = image_w, height=image_h, res = 300)

  plot(
    lstRast[[i]],
    ext = ext(lstRast[[1]]),
    axes = FALSE,
    box = FALSE,
    legend = FALSE
  )

  dev.off()

  map <- magick::image_read(f)

  # Date from the raster name
  date <- names(lstRast)[i]

  # Add date to image
  map <- magick::image_annotate(
    map,
    text = date,
    gravity = "northwest",
    location = "+10+10",
    size = 50,
    color = "white",
	boxcolor = "black",
    degrees = 0
  )

  map
})
```
Joining images
```r
maps <- magick::image_join(maps)
```
Applying legend to each frame (color palette also taken from: (https://custom-scripts.sentinel-hub.com/custom-scripts/sentinel-2/ulyssys_water_quality_viewer/)
```r
legend <- magick::image_resize(magick::image_read("palette.png"),sprintf("%dx",legend_width))


maps <- magick::image_composite(
  maps,
  legend,
  operator = "over",
  gravity = "southeast",
  offset = "+10+10"
)
```
Writing and saving the gif file
```r
gif <- magick::image_animate(
  maps,
  fps = 0.5,
  loop = 0
)

magick::image_write(
  gif,
  "map_animation.gif"
)

```
<img width="1178" height="2024" alt="map_animation" src="https://github.com/user-attachments/assets/6ec8effb-cb7e-4022-9503-5a1e47df9a28" />
