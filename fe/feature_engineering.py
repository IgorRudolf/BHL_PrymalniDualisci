import pandas as pd
import numpy as np
import math
from sklearn.base import BaseEstimator, TransformerMixin

class FeatureEngineering(BaseEstimator, TransformerMixin):
    def fit(self, X, y=None):
        return self
    
    def transform(self, X):
        # 1. Proportion of the day (Długość dnia jako proporcja)
        X['Proportion_Of_Day'] = (X['Hour'] - X['TimeSunRise_first'].astype(float)) / (X['TimeSunSet_first'].astype(float) - X['TimeSunRise_first'].astype(float))

        # 2. Hour in sinusoidal form (Godzina w postaci sinusoidalnej)
        X['Hour_Sin'] = np.sin(2 * np.pi * X['Hour'] / 24)
        X['Hour_Cos'] = np.cos(2 * np.pi * X['Hour'] / 24)

        # 3. Temperature amplitude (Amplituda temperatury w ciągu dnia)
        X['Temp_Amplitude'] = X['Temperature_max'] - X['Temperature_min']

        # 4. Temperature ratio (Stosunek średniej temperatury do maksymalnej temperatury)
        X['Temp_Ratio'] = X['Temperature_mean'] / X['Temperature_max']

        # 5. Wind energy as a function of speed (Energia wiatru jako funkcja prędkości)
        X['Wind_Energy'] = X['Speed_mean']**2

        # 6. Wind direction distribution (Rozkład kierunku wiatru)
        X['WindDir_Sin'] = np.sin(X['WindDirection_mean'] * np.pi / 180)
        X['WindDir_Cos'] = np.cos(X['WindDirection_mean'] * np.pi / 180)

        # 7. Humidity ratio (Cechy związane z wilgotnością)
        X['Humidity_Ratio'] = X['Humidity_mean'] / X['Humidity_max']

        # 8. Time to noon (Czas do południa)
        X['Time_To_Noon'] = abs((X['Hour'] - X['TimeSunRise_first'].astype(float)) - (X['TimeSunSet_first'].astype(float) - X['TimeSunRise_first'].astype(float)) / 2)

        # 9. Interaction between wind and humidity (Interakcje między temperaturą, wilgotnością i wiatrem)
        X['Wind_Humidity_Interaction'] = X['Speed_mean'] * X['Humidity_mean']

        # 10. Interaction between temperature and time of day (Interakcja między temperaturą a czasem w ciągu dnia)
        X['Temp_Time_Interaction'] = X['Temperature_mean'] * X['Proportion_Of_Day']

        X.drop(['TimeSunSet_first', 'Temp_Amplitude'], axis=1, inplace=True)

        return X