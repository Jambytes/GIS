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
library(dplyr)

getwd()

alaska <- st_read('alaska/Regions.shp')
plot(alaska['REGION_NAM'])
alCities <-  st_read('alaska/Cities.shp')
alRivers <-  st_read('alaska/NavigableWater.shp')


st_crs(alaska)
head(alCities)
str(alCities)

incicdent_city <- alCities[alCities$NAME == 'Fairbanks',]
incicdent_city

buffered_incident_city <- st_buffer(incicdent_city, 140000)
bic <- st_geometry(buffered_incident_city)
plot(st_geometry(alaska))
plot(bic, add=TRUE)
plot(polluted_region, col = 'bisque2', add=TRUE)
plot(st_geometry(incicdent_city), col = "black", add=TRUE)
plot(st_geometry(incident_rivers), col = 'blue', add = TRUE)
plot(st_geometry(u_buffered_incident_rivers), col = 'blue', add=TRUE)

intersect_river_city <- st_intersects(alRivers, bic)
lengths(intersect_river_city)

alRiver[lengths(intersect_river_city) > 0,]
incident_rivers <- alRivers[lengths(intersect_river_city) > 0,]
incident_rivers

buffered_incident_rivers <- st_buffer(incident_rivers, 10000)
u_buffered_incident_rivers <- st_union(buffered_incident_rivers)

united_alaska <- st_union(alaska["REGION_NAM"])
area_alas <- st_area(united_alaska)
area_alas

area_of_interest <- st_area(polluted_region)
plot(polluted_region)
polluted_region <- st_union(u_buffered_incident_rivers, buffered_incident_city)
area_of_interest / area_alas *100 

#grammar for coloration in the st_geometry function / plot function
# Bsp.: plot(st_geometry(alaska), col = rgb(1,0,0,.5)
#muss man etwas ausprobieren
