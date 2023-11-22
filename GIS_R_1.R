# Pakete ####
install.packages("tidyverse")
install.packages('sf')
install.packages('terra')
install.packages('sp')
install.packages('raster')
install.packages('ncdf4')
install.packages('ggmap')
install.packages('leaflet')
install.packages('tmap') 
install.packages('mapview')


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

# Daten ####
getwd()
setwd('"C:/Users/user/OneDrive/Desktop/Karriere/Agrar/Sweeter Swerv/Im Studium/GIS/Seminar/R/GIS/data/data"')

temperature <- raster("data/data/other/temperature.tif")



districts <- st_read("data/data/ger/districts.shp")
# Verarbeitung ####
summary(temperature) #raster Dateien sind immer innerhalb des rechteckigen Koordinatensystem
# das bedeutet dass sehr viele Werte 'NA' sind, die den weißen Hintergrund ausmachen!


districts_simple <- districts[,c("GEN", "AGS", "EWZ")]
districts_smallpop <- districts[districts$EWZ < 200000,]

nrw_districs <- st_transform(districts[substr(districts$AGS,1,2) == "05",])

districts_geom <- st_geometry(districts)             #nur noch die Polygone
districts_attributes <- st_drop_geometry(districts)  #nur noch die Attribute


model <- lm(EWZ~SHAPE_AREA, districts)
summary(model)                         #Statitische Berechnung der Beziehung zwischen Fläche und Einwohnerzahl


districts$PD <- districts$EWZ / districts$SHAPE_AREA

districts <- st_transform(districts, crs(temperature))

nrw_temp <- crop(temperature, nrw_districs)



# Projezierung ####
plot(temperature)

plot(districts["EWZ"])

plot(districts_smallpop["EWZ"])

plot(nrw_districs["EWZ"])

plot(EWZ~SHAPE_AREA, districts)        #visualisierung der Korrelation von SHAPE_AREA und Population

abline(model)
plot(districts["PD"])

plot(districts_geom, add=TRUE)
st_crs(districts_geom)
crs(temperature)

plot(nrw_temp)
plot(st_geometry(nrw_districs), add = TRUE)

nrw_temp <- mask(temperature, nrw_districs)
nrw_temp <- crop(temperature, nrw_districs)
plot(nrw_temp)


# Notizen ####

# Es ist besser die Shapefiles über Vektor zu bearebiten um nicht zu viele Daten zu verlieren. 
# Die Übersetzung von den Rasterdaten in andere Koordinatensysteme kann zu Verlusten führen, da diese dann
# gestaucht, gestreckt und/oder verzogen werden!