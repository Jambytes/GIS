library(terra)
library(sp)

getwd()
setwd("C:/Users/user/OneDrive/Desktop/Karriere/Agrar/Sweeter Swerv/Im Studium/GIS/Seminar/R/GIS/data/data/weather")


files <- list.files( "C:/Users/user/OneDrive/Desktop/Karriere/Agrar/Sweeter Swerv/Im Studium/GIS/Seminar/R/GIS/data/data/weather",
            pattern = "07.asc.gz", full.names = TRUE)
stacked = NULL


for (file in files){
  
  #Die Schleife packt einen Wert aus der Liste "files" in eine Zeile = 'Newlayer'
  #Dann packt die SChleife die Zeile in die 'Stacked' Variable und den Rest der 'stacked' Variable in die selbige
  #sodass in 'stacked' mehrere Zeilen beschrieben werden.
  
  newlayer <- rast(read.asciigrid(file))
  stacked  <-  c(newlayer, stacked)
  
  
}


str(stacked)
stacked
head(stacked)

crs(stacked) <- "EPSG:31467"
stacked = stacked / 10
summary(stacked) #Datei sehr groß

temp_mean <- app(stacked, mean)
temp_max <- app(stacked, max)
temp_min <- app(stacked, min)

t_dif <- stacked[[1]] - temp_mean

plot(t_dif)
