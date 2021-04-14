

ee_date = function(date){
  
  #sprawdza, czy wymagane pakiety są posiadane, jeżeli nie - wyświetla komunikat błędu
  
  if ((library(leaflet) == F) ||
      (library(stringr) == F ||
       (library(RColorBrewer) == F) ||
       (library(magrittr) == F))) {
    stop('Funkcja wymaga następujących pakietów: leaflet, stringr, RColorBrewer, magrittr')
  }
  
  earthquakes = read.csv('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv',
                         encoding = 'UTF-8')
  
  library(stringr)
  
  earthquakes$time = str_replace_all(earthquakes$time, pattern = '\\T', replacement = '\\ ')
  
  #dodanie kolejnej kolumny tylko z dniem
  
  earthquakes = data.frame(earthquakes, date = as.Date(earthquakes$time))
  
  library(leaflet)
  library(magrittr)
  library(RColorBrewer)
  
  #wydzielenie wartości trzęsień z podanego dnia
  
  ee = earthquakes[earthquakes$date == date, ]
  
  #wyświetlenie błędu, jeżeli podany argument wykracza poza dostępne dane
  
  if (date < tail(earthquakes$date, 1)){
    stop('Maksymalny zakres danych od', '\ ', tail(earthquakes$date, 1), '\ ', 
         'do', '\ ', head(earthquakes$date, 1))
  }

  #wiadomość podaje okres od ostatniej do pierwszej daty w ramce danych
  
  message('Dane pochodzą z United States Geological Survey i obejmują czas od', '\ ',
          tail(ee$time, 1), '\ ', 'do', '\ ', head(ee$time, 1)) 
  
  #skala podziału palety kolorów
  
  color_bin = seq((min(earthquakes$mag, na.rm = T)), 9, by = 1.5) 
  
  #paleta kolorów, zależna od wartości magnitudy
  
  color_palette = colorBin(palette = 'YlOrRd', 
                           bins = color_bin, 
                           na.color = 'transparent', 
                           domain = ee$mag) 
  
  #tworzenie mapy za pomocą pakietu 'leaflet' 
  
  map = leaflet() %>%
    
    #dodanie podkładu w postaci mapy świata, której dostawcą jest Esri
    
    addTiles() %>%
    
    addProviderTiles("Esri.WorldImagery") %>%
    
    #ustawianie domyślnego widoku mapy
    
    setView( lat=0, lng=0 , zoom=2) %>%
    
    #dodanie znaczników na mapie, ich wielkość i kolor zależy od wartości magnitudy
    
    addCircleMarkers(data = ee, 
                     lng = ee$longitude, 
                     lat = ee$latitude,
                     radius = ee$mag*10^0.06,
                     fillColor = ~color_palette(mag), 
                     fillOpacity = 0.9, 
                     stroke = FALSE,
                     
                     #dodanie okienek z podanymi danymi, które wyskakują po kliknięciu w miejscu trzęsienia
                     
                     popup = paste('<b>Place:</b>', ee$place, 
                                   '<b>Date & time:</b>', ee$time,
                                   '<b>Magnitude:</b>', ee$mag, 
                                   '<b>Depth:</b>', ee$depth, sep = '</br>')) %>%
    
    #dodanie legendy z odpowiednimi kolorami, wartościami magnitudy i tytułem 
    
    addLegend( pal = color_palette, 
               values = ee$mag, 
               opacity= 0.8,
               title = 'Magnitude', 
               position = 'bottomright') %>%
    
    #dodanie miniaturowej mapy, określenie jej pozycji i wielkości
    
    addMiniMap(position = 'bottomleft', height = 90)
  
  #finalny wygląd mapy
  
  map
  
}



#przykłady

ee_date('2021-03-10')
ee_date('2021-03-15')


