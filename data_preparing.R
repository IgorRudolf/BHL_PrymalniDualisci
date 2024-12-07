library(dplyr)

setwd('C:/bhl/data/data/initial_data')

data<- read.csv("SolarPrediction.csv", h= TRUE)

data

library(dplyr)
library(lubridate)

# Wczytanie danych
data <- read.csv("SolarPrediction.csv", header = TRUE)

# Przetwarzanie danych
data_clean <- data %>%
  mutate(
    # Konwersja kolumny Data na format daty
    Data = as.Date(Data, format = "%m/%d/%Y"),
    
    # Wyciąganie dnia i miesiąca
    Day = as.numeric(format(Data, "%d")),
    Month = as.numeric(format(Data, "%m")),
    
    # Wyciąganie godziny
    Hour = hour(hms::as_hms(Time)), 
    
    # Konwersja na obiekty czasu dla wschodu i zachodu słońca
    TimeSunRise = hms::as_hms(TimeSunRise),
    TimeSunSet = hms::as_hms(TimeSunSet),
    
    # Obliczenie różnicy w minutach między wschodem i zachodem słońca
    SunDurationMinutes = as.numeric(difftime(TimeSunSet, TimeSunRise, units = "mins"))
  ) %>%
  # Usunięcie kolumny UNIXTime
  select(-UNIXTime)

# Grupowanie danych i agregacja
aggregated_data <- data_clean %>%
  group_by(Day, Month, Hour) %>%
  summarise(
    Mean_Temperature = mean(Temperature, na.rm = TRUE),
    Min_Temperature = min(Temperature, na.rm = TRUE),
    Max_Temperature = max(Temperature, na.rm = TRUE),
    SD_Temperature = sd(Temperature, na.rm = TRUE),
    
    Mean_Pressure = mean(Pressure, na.rm = TRUE),
    Min_Pressure = min(Pressure, na.rm = TRUE),
    Max_Pressure = max(Pressure, na.rm = TRUE),
    SD_Pressure = sd(Pressure, na.rm = TRUE),
    
    Mean_Humidity = mean(Humidity, na.rm = TRUE),
    Min_Humidity = min(Humidity, na.rm = TRUE),
    Max_Humidity = max(Humidity, na.rm = TRUE),
    SD_Humidity = sd(Humidity, na.rm = TRUE),
    
    Mean_WindDirection = mean(WindDirection.Degrees., na.rm = TRUE),
    Min_WindDirection = min(WindDirection.Degrees., na.rm = TRUE),
    Max_WindDirection = max(WindDirection.Degrees., na.rm = TRUE),
    SD_WindDirection = sd(WindDirection.Degrees., na.rm = TRUE),
    
    Mean_Speed = mean(Speed, na.rm = TRUE),
    Min_Speed = min(Speed, na.rm = TRUE),
    Max_Speed = max(Speed, na.rm = TRUE),
    SD_Speed = sd(Speed, na.rm = TRUE),
    
    Mean_Radiation = mean(Radiation, na.rm = TRUE), # Średnia dla Radiation
    
    SunDurationMinutes = mean(SunDurationMinutes, na.rm = TRUE), # Średnia długość dnia
    First_TimeSunRise = first(TimeSunRise), # Zachowanie TimeSunRise
    First_TimeSunSet = first(TimeSunSet)    # Zachowanie TimeSunSet
  )

# Wyświetlenie nazw kolumn
colnames(aggregated_data)

# Podział danych na zbiory treningowe i testowe
set.seed(123)
train_indices <- sample(seq_len(nrow(aggregated_data)), size = 0.8 * nrow(aggregated_data))

train_data <- aggregated_data[train_indices, ]
test_data <- aggregated_data[-train_indices, ]

# Zapis do plików CSV
write.csv(train_data, "train.csv", row.names = FALSE)
write.csv(test_data, "test.csv", row.names = FALSE)

cat("Dane zostały podzielone i zapisane do plików:\n - train.csv\n - test.csv\n")









