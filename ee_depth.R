ee_depth = function(depth_min, depth_max){
  
  
  if ((library(leaflet) == F) ||
      (library(stringr) == F ||
       (library(RColorBrewer) == F) ||
       (library(magrittr) == F))) {
    
    stop('Funkcja wymaga następujących pakietów: leaflet, stringr, RColorBrewer, magrittr')
  }
  
  earthquakes = read.csv('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv',
                         encoding = 'UTF-8')
  #aktywuje pakiet
  library(stringr)
  
  #zamienia dane w kolumnie time według podanego wzoru
  earthquakes$time = str_replace_all(earthquakes$time, pattern = '\\T', replacement = '\\ ')
  
  #dodanie kolejnej kolumny tylko z dniem
  
  earthquakes = data.frame(earthquakes, date = as.POSIXct(earthquakes$time))
  
  #wiadomość podaje okres od ostatniej do pierwszej daty w ramce danych
  
  message('Dane pochodzą z United States Geological Survey i obejmują czas od', '\ ',
          tail(earthquakes$time, 1), '\ ', 'do', '\ ', head(earthquakes$time, 1))
  #aktywuje pakiety
  library(leaflet)
  library(magrittr)
  library(RColorBrewer)
  
  #wyświetla komunikat błędu w momencie, kiedy podany argument nie jest wartością numeryczną
  
  if (!is.numeric(depth_min) | !is.numeric(depth_max)) {
    
    stop('Argument musi być typu numerycznego')
    
  } 
  
  if (depth_min > depth_max) {
    stop('Zakres musi być przedstawiony od min do max')
  }
  
  
  #wydzielenie wartości trzęsień na głębokości równej podanemu argumentowi, bądź zawierającemu się w podanym przedziale
  
  ee = earthquakes[earthquakes$depth>= depth_min & earthquakes$depth <= depth_max, ]
  
  #skala podziału palety kolorów
  
  color_bin = seq(0,675, by = 75) 
  
  
  #paleta kolorów, zależna od wartości magnitudy
  
  color_palette = colorBin(palette = 'YlOrRd', 
                           bins = color_bin, 
                           na.color = 'transparent', 
                           domain = ee$depth) 
  #ukrycie komunikatu ostrzegawczego
  
  options(warn = -1)
  
  #tworzenie mapy za pomocą pakietu 'leaflet' 
  
  map = leaflet() %>%
    
    #dodanie podkładu w postaci mapy świata, której dostawcą jest Esri
    
    addTiles() %>%
    
    addProviderTiles("Esri.WorldImagery") %>%
    
    #ustawianie domyślnego widoku mapy
    
    setView( lat=0, lng=0 , zoom=2) %>%
    
    #dodanie znaczników na mapie, ich wielkość i kolor zależy od magnitudy
    
    addCircleMarkers(data = ee, 
                     lng = ee$longitude, 
                     lat = ee$latitude,
                     radius = ee$mag*10^0.06,
                     fillColor = ~color_palette(depth), 
                     fillOpacity = 0.9, 
                     stroke = FALSE,
                     
                     #dodanie okienek z podanymi danymi, które wyskakują po kliknięciu w miejscu trzęsienia
                     
                     popup = paste('<b>Place:</b>', ee$place, 
                                   '<b>Date & time:</b>', ee$time,
                                   '<b>Magnitude:</b>', ee$mag, 
                                   '<b>Depth:</b>', ee$depth, sep = '</br>')) %>%
    
    #dodanie legendy z odpowiednimi kolorami, wartościami głębokości i tytułem 
    
    addLegend( pal = color_palette, 
               values = ee$depth, 
               opacity= 0.8,
               title = 'Depth', 
               position = 'bottomright') %>%
    
    #dodanie miniaturowej mapy, określenie jej pozycji i wielkości
    
    addMiniMap(position = 'bottomleft', height = 90)
  
  #finalny wygląd mapy
  
  map
  
}


#przykłady


ee_depth(100,200)
ee_depth(200,)
ee_depth(200,"aaa")
