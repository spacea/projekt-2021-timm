Grupa:
------
Aleksandra Stefaniak,
Urszula Sołtykowska,
Maria Timm


Założenia i opis projektu:
------

Nasz projekt pozwala na przedstawienie oraz zwizualizowanie na mapie danych dotyczących trzęsień Ziemi na świecie w sposób wybrany przez odbiorcę. 
Stworzone funkcje, wykorzystujące pakiety wymienione poniżej, dają możliwość między innymi: wybrania zakresu głębokości zjawiska, wartości magnitudy czy też wyświetlenia trzęsień z dnia, który nas interesuje. 
Pozwala to w szybki i przejrzysty sposób znalezienie interesujących odbiorcę danych. 
Praca z nimi jest również klarowniejsza, ponieważ wprowadzona została paleta kolorów ułatwiająca ich odczytywanie. 
Dodatkowo, w razie błędów, wyświetlane są pomocne komunikaty, nakierowujące adresata projektu na to jaki wystąpił problem. 

_Dane użyte w naszej pracy pochodzą z amerykańskiej agencji naukowo-badawczej (USGS)._

Pakiety potrzebne do uruchomienia kodu:
------
leaflet
stringr
RColorBrewer
magrittr

Funkcje:
------
**ee_mag ** - argumentami funkcji jest zakres magnitudy, jaki ma zostać przedstawiony na mapie.

         ee_mag = function(mag_min, mag_max){ ... }

         mag_min - wartość minimalna zakresu
         mag_max - wartość maksymalna zakresu
**ee_mag_min** - argumentem (mag_min) funkcji jest minimalna wartość magnitudy, jaka ma zostać przedstawiona na mapie.

         ee_mag_min = function(mag_min){ ... }

**ee_date** - argumentem (date) funkcji jest data. Funkcja wydziela trzęsienia, które zarejestrowano danego dnia.

         ee_date = function(date){ ... }

**ee_depth** - argumentami funkcji jest zakres głębokości, na jakich wystąpiło trzęsienie, jaki ma zostać przedstawiony na mapie. 

         ee_depth = function(depth_min, depth_max){ ... }
         
         depth_min - wartość minimalna zakresu
         dwpth_max - wartość maksymalna zakresu
         
**ee_depth_min** - argumentem (depth_min) funkcji jest minimalna głębokość, na której wystąpiło trzęsienie, jaka ma zostać przedstawiona na mapie.
          
          ee_depth_min = function(depth_min){ ... }
W trakcie wykonywania kodu wyświetlana jest wiadomość podająca pochodzenie danych oraz rozpiętość czasową po wcześniejszym ich pobraniu i przygotowaniu.

         earthquakes = read.csv('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv',
                         encoding = 'UTF-8')
         
         library(stringr)
         
         earthquakes$time = str_replace_all(earthquakes$time, pattern = '\\T', replacement = '\\ ')
         
         earthquakes = data.frame(earthquakes, date = as.POSIXct(earthquakes$time))
         
         message('Dane pochodzą z United States Geological Survey i obejmują czas od', '\ ',
          tail(earthquakes$date, 1), '\ ', 'do', '\ ', head(earthquakes$date, 1))
          
W momencie, kiedy wymagane pakiety nie są obecne, funkcja odsyła komunikat błędu za pomocą:

         if ((library(leaflet) == F) ||
             (library(stringr) == F ||
             (library(RColorBrewer) == F) ||
             (library(magrittr) == F))) {
    
    stop('Funkcja wymaga następujących pakietów: leaflet, stringr, RColorBrewer, magrittr')
  }
  
Sprawdza również, czy podane argumenty są typu numerycznego. Za pomocą pakietu lefalet funkcja tworzy mapę według podanych parametrów i na samym końcu wyświetla ją.


          
We wszystykich funkcjach tworzenie mapy odbywa się na takiej samej zasadzie, za pomocą pakietu leaflet i RColorBrewer, dostarczającego paletę kolorów.

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

