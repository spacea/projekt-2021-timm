
earthquakes = read.csv('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv',
                       encoding = 'UTF-8')

earthquakes$time = str_replace_all(earthquakes$time, pattern = '\\T', replacement = '\\ ')

library(leaflet)
library(magrittr)
library(stringr)
library(RColorBrewer)

ee_mag_min = function(mag_min){
  
  ee = earthquakes[earthquakes$mag > mag_min, ]
  
  color_bin = seq(mag_min,9, by = 1)
  
  color_palette = colorBin(palette = 'YlOrRd', 
                           bins = color_bin, 
                           na.color = 'transparent', 
                           domain = ee$mag)
  
  map = leaflet() %>%
    
    addTiles() %>%
    
    addProviderTiles("Esri.WorldImagery") %>%
    
    setView( lat=0, lng=0 , zoom=2) %>%
    
    addCircleMarkers(data = ee, 
                     lng = ee$longitude, 
                     lat = ee$latitude,
                     radius = ee$mag*10^0.06,
                     fillColor = ~color_palette(mag), 
                     fillOpacity = 0.9, 
                     stroke = FALSE,
                     popup = paste('<b>Place:</b>', ee$place, 
                                   '<b>Date & time:</b>', ee$time,
                                   '<b>Magnitude:</b>', ee$mag, 
                                   '<b>Depth:</b>', ee$depth, sep = '</br>')) %>%
    
    addLegend( pal= color_palette, 
               values= ee$mag, 
               opacity=0.8, 
               title = 'Magnitude', 
               position = 'bottomright') %>%
    
    addMiniMap(position = 'bottomleft', height = 90)
  
  map
  
}


#przykłady

ee_mag_min(0)
ee_mag_min(2)
ee_mag_min(5)


