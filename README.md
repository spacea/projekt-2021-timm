Grupa:

Aleksandra Stefaniak
Urszula Sołtykowska
Maria Timm

Założenia projektu:



Funkcje:

ee_mag - argumentami funkcji jest zakres magnitudy, jaki ma zostać przedstawiony na mapie.

         ee_mag = function(mag_min, mag_max){ ... }

         mag_min - wartość minimalna zakresu
         mag_max - wartość maksymalna zakresu

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

ee_mag_min - argumentem (mag_min) funkcji jest minimalna wartość magnitudy, jaka ma zostać przedstawiona na mapie

ee_date - argumentem (date) funkcji jest data. Funkcja wydziela trzęsienia, które zarejestrowano danego dnia.

