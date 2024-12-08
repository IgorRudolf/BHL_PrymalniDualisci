library(dplyr)

setwd('C:/bhl/data/data/model_data')

data<- read.csv("train_data_fe.csv", h= TRUE)

colnames(data)

new_model<- lm(Radiation_mean~., data=data)

plot(new_model$res)

#Na wykresie widzimy pewien brak losowości – dolna część wykresu pokazuje, że 
#niektóre obserwacje mają systematycznie duże ujemne residua (np. poniżej -400), 
#co może oznaczać problem z modelem.

#Wariancja reszt wydaje się większa w dolnym zakresie 
#(negatywne reszty są bardziej rozproszone niż pozytywne). 
#Może to sugerować heteroskedastyczność.

#Niektóre punkty są bardzo oddalone od poziomu 0 (np. poniżej -400). 
#Te obserwacje mogą być wartościami odstającymi, które warto przeanalizować.

threshold<-3 * sd(new_model$res)

outliers_residuals <- which(abs(new_model$residuals) > threshold)
outliers_rstandard <- as.numeric(which(abs(rstandard(new_model)) > 2))


outliers <- unique(c(outliers_residuals, outliers_rstandard))

plot(new_model, 1) #czerwona prosta nie uklada linii prostej

plot(new_model, 2) #wykres QQ pokazuje, ze nie jest prawdziwe zalozenie
#dotyczace rozkladu normalnego rezyduoow, jest problem w ogonach rozkladow

plot(new_model, 4)
#widzimy, ze bardzo wplywowa obserwacja ma indeks 1001

plot(new_model, 5)

outliers<- unique(c(outliers, 1001))


# Usunięcie wartości odstających z danych
data_cleaned <- data[-outliers, ]

# Stworzenie nowego modelu regresji liniowej na danych bez wartości odstających
new_model_no_outliers <- lm(Radiation_mean ~ ., data = data_cleaned)

data_cleaned




# Podsumowanie nowego modelu
summary(new_model_no_outliers)

plot(new_model_no_outliers$res)
abline(h=0)

plot(new_model_no_outliers, 1)
plot(new_model_no_outliers, 2)

plot(new_model_no_outliers, 3)
#tutaj mamy problem

#sprobujmy zrobic transformacje zmiennej celu
data_cleaned$Radiation_mean <- log(data_cleaned$Radiation_mean + 1)

mod3<- lm(Radiation_mean ~ ., data = data_cleaned)

plot(mod3, 3)

outliers<-as.numeric(which(abs(rstudent(mod3)) > 2))

data_cleaned<- data_cleaned[-outliers, ]

mod4<- lm(Radiation_mean ~ ., data = data_cleaned)

summary(mod4)

#wyrzucamy kolumny od siebie zalezne:

# Znalezienie kolumn z NA w modelu
na_columns <- names(which(is.na(coef(mod3))))

# Usunięcie kolumn z NA z danych
data_cleaned <- data_cleaned[, !(colnames(data_cleaned) %in% na_columns)]

mod5<- lm(Radiation_mean ~ ., data = data_cleaned)



###########################################

# Wyciągnięcie t-statystyk
t_stats <- summary(mod5)$coefficients[, "t value"]

# Posortowanie zmiennych według t-statystyk (malejąco)
sorted_variables <- names(sort(abs(t_stats), decreasing = TRUE))
sorted_variables <- sorted_variables[!sorted_variables %in% "(Intercept)"]  # Usuń intercept

# Inicjalizacja listy do przechowywania modeli i ich AIC/BIC
models_aic <- list()
models_bic <- list()

# Iteracyjne dopasowanie modeli
for (i in seq_along(sorted_variables)) {
  # Wybierz zmienne do modelu
  selected_variables <- sorted_variables[1:i]
  
  # Stwórz formułę modelu
  formula <- as.formula(paste("Radiation_mean ~", paste(selected_variables, collapse = " + ")))
  
  # Dopasuj model
  model <- lm(formula, data = data_cleaned)
  
  # Oblicz AIC i BIC
  models_aic[[i]] <- list(model = model, aic = AIC(model))
  models_bic[[i]] <- list(model = model, bic = BIC(model))
}

# Znajdź model z minimalnym AIC
best_aic_model <- models_aic[[which.min(sapply(models_aic, function(x) x$aic))]]$model

# Znajdź model z minimalnym BIC
best_bic_model <- models_bic[[which.min(sapply(models_bic, function(x) x$bic))]]$model

# Podsumowanie najlepszego modelu według AIC
cat("Najlepszy model według AIC:\n")
summary(best_aic_model)

plot(best_aic_model, 3)

# Podsumowanie najlepszego modelu według BIC
cat("Najlepszy model według BIC:\n")
summary(best_bic_model)

plot(mod4, 2)

plot(best_aic_model, 3)

summary(best_aic_model)

mean_radiation