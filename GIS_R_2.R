# Bücherei ####
library(tidyverse)
library(sf)
library(terra)
library(sp)
library(raster)
library(ncdf4)
library(ggmap)
library(leaflet)
library(tmap)
library(mapview)
library(tidyterra)

#Canvas ####
getwd()
setwd("C:/Users/user/OneDrive/Desktop/Karriere/Agrar/Sweeter Swerv/Im Studium/GIS/Seminar/R/GIS/data/data")
getwd()

ger <- st_read('ger/districts.shp')
ger$pd <- ger$EWZ / ger$SHAPE_AREA
plot(ger['pd'])

satlight <- rast('ger/light.tif')
st_crs(ger)
crs(satlight)

ger <- st_transform(ger, crs(satlight))
st_crs(ger)

plot(satlight)
plot(st_geometry(ger), add=TRUE, border = 'yellow')

extvalues <- extract(satlight, ger, fun=mean)
ger$light <- extvalues$light

plot(EWZ ~ light, data= ger)
plot(pd ~ light, data = ger)
plot(ger[c('pd', 'light')])

lmodel <- lm(pd  ~ light, data = ger)
summary(lmodel)

ger$pd_estimated <- predict(lmodel)
ger$pd_residuals <- resid(lmodel)

ger$pd_relativresiduals <- ger$pd_residuals / ger$pd

plot(ger[c('pd', 'pd_estimated')])
plot(ger[c('pd', 'pd_relativresiduals')])



hist(ger$pd_relativresiduals)

pop_predict <- predict(satlight, lmodel)
plot(pop_predict)
plot(pop_predict, color = grey.colors(255,.0,1))
