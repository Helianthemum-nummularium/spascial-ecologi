# This is a Header
## This is a subheader
## How to import data in R
Packages required:
```r
library(terra) #managing spatial data
library(imageRy) #manipulating remote sensing data
```
Step 1. Set working directory (use backtick (Alt+96) to insert code)
```r
library(terra)
setwd("C:/Users/Elia/Desktop/UniBo/ERRE")
```
check directory with
```r
getwd()
```
Step 2. Import data and display image info
```r
group <- rast("AnImage.JPG")
group
```
Step 3. Plot image with RGB colors
```r
im.plotRGB(group, r=1, g=2, b=3) #1=R, 2=G, 3=B
```
oh, no! The image is flipped

```r
group <- flip(group)
im.plotRGB(group, r=1, g=2, b=3)
```
Step 4. Let's export the output
```r
png("group.png")
im.plotRGB(group, r=1, g=2, b=3)
dev.off()
```
the output looks like:

<img width="480" height="480" alt="group" src="https://github.com/user-attachments/assets/f4e8957f-23a9-460d-865d-644222a8c093" />

Step 5. create false color image
```r
png("not_group.png")
im.plotRGB(group, r=2, g=1, b=3)
dev.off()
```
the output looks like:

<img width="480" height="480" alt="not_group" src="https://github.com/user-attachments/assets/0fae1105-a1e0-4657-addd-1a42001cc282" />
