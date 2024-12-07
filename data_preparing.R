library(dplyr)

setwd('C:/bhl/data')

data<- read.csv("SolarPrediction.csv", h= TRUE)

data

library(dplyr)
library(lubridate)

data_clean <- data %>%
  
  mutate(
    Day = as.numeric(format(as.Date(Data, format = "%m/%d/%Y"), "%d")),
    Month = as.numeric(format(as.Date(Data, format = "%m/%d/%Y"), "%m")),
    
    Hour = hour(hms::as_hms(Time)), 
    
    TimeSunRise = hms::as_hms(TimeSunRise),
    TimeSunSet = hms::as_hms(TimeSunSet),
    
    SunDurationMinutes = as.numeric(difftime(TimeSunSet, TimeSunRise, units = "mins"))
  ) %>%
  
  select(-UNIXTime, -Time) %>%

  filter(Hour >= hour(TimeSunRise) & Hour <= hour(TimeSunSet))

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
    
    Mean_Radiation = mean(Radiation, na.rm = TRUE), # Dodano brakującą średnią dla Radiation
    
    SunDurationMinutes = mean(SunDurationMinutes, na.rm = TRUE) # Zmieniono nazwę kolumny
  )

colnames(aggregated_data)

aggregated_data

set.seed(123)


train_indices <- sample(seq_len(nrow(aggregated_data)), size = 0.8 * nrow(aggregated_data))


train_data <- aggregated_data[train_indices, ]
test_data <- aggregated_data[-train_indices, ]

write.csv(train_data, "train.csv", row.names = FALSE)
write.csv(test_data, "test.csv", row.names = FALSE)






