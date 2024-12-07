import pandas as pd
from sklearn.base import BaseEstimator, TransformerMixin


class DateTimeTransformer(BaseEstimator, TransformerMixin):
    """
    Transformer class to preprocess datetime features in a pandas DataFrame.
    """

    def fit(self, X, y=None):
        """
        Fit method for the transformer.

        Parameters:
        - X: pandas DataFrame
            The input DataFrame to fit the transformer on.
        - y: None
            The target variable (not used in this transformer).

        Returns:
        - self: DateTimeTransformer
            The fitted transformer object.
        """
        return self
    
    def transform(self, X):
        """
        Transform method for the transformer.

        Parameters:
        - X: pandas DataFrame
            The input DataFrame to transform.

        Returns:
        - X_transformed: pandas DataFrame
            The transformed DataFrame with datetime features processed.
        """
        X = X.copy()
        
        X['Day'] = pd.to_datetime(X['Data'], format="%m/%d/%Y %I:%M:%S %p").dt.day
        X['Month'] = pd.to_datetime(X['Data'], format="%m/%d/%Y %I:%M:%S %p").dt.month
        X = X.drop(columns=['Data'])
        
        X['Hour'] = pd.to_datetime(X['Time'], format='%H:%M:%S').dt.hour
        
        X['SunDurationMinutes'] = (pd.to_timedelta(X['TimeSunSet']) - pd.to_timedelta(X['TimeSunRise'])).dt.total_seconds() / 60
        X['TimeSunRise'] = X['TimeSunRise'].apply(lambda x: int(x.split(':')[0]) + int(x.split(':')[1])/60)
        X['TimeSunSet'] = X['TimeSunSet'].apply(lambda x: int(x.split(':')[0]) + int(x.split(':')[1])/60)
        X = X.drop(columns=['UNIXTime'])

        return X


class GroupByAggregator(BaseEstimator, TransformerMixin):
    """
    A transformer class that performs groupby aggregation on the input data.
    
    This class aggregates the input data based on the specified columns and calculates
    various statistical measures for each group, such as mean, minimum, maximum, and standard deviation.
    
    Attributes:
        None
        
    Methods:
        fit(X, y=None): Fit the transformer to the input data.
        transform(X): Transform the input data by performing groupby aggregation.
    """
    
    def fit(self, X, y=None):
        """
        Fit the transformer to the input data.
        
        Parameters:
            X (pandas.DataFrame): The input data to fit the transformer on.
            y (optional): The target variable (ignored in this implementation).
        
        Returns:
            self (GroupByAggregator): The fitted transformer object.
        """
        return self
    
    def transform(self, X):
        """
        Transform the input data by performing groupby aggregation.
        
        Parameters:
            X (pandas.DataFrame): The input data to transform.
        
        Returns:
            aggregated (pandas.DataFrame): The transformed data after groupby aggregation.
        """
        X = X.copy()
        X = X.rename(columns={'WindDirection(Degrees)': 'WindDirection'})

        aggregated = X.groupby(['Day', 'Month', 'Hour']).agg({
            'Temperature': ['mean', 'min', 'max', 'std'],
            'Pressure': ['mean', 'min', 'max', 'std'],
            'Humidity': ['mean', 'min', 'max', 'std'],
            'WindDirection': ['mean', 'min', 'max', 'std'],
            'Speed': ['mean', 'min', 'max', 'std'],
            'Radiation': 'mean',
            'SunDurationMinutes': 'mean',
            'TimeSunRise': 'first',
            'TimeSunSet': 'first'
        }).reset_index()
        
        aggregated.columns = ['_'.join(col).strip('_') for col in aggregated.columns.values]
        
        sd_columns = [col for col in aggregated.columns if col.endswith('_std')]
        aggregated[sd_columns] = aggregated[sd_columns].fillna(0) 
        # when only one value is aggregated the sd is calc to be NaN 
        # but we can interpret this as 0
        
        return aggregated

class FilterByDaylight(BaseEstimator, TransformerMixin):
    def fit(self, X, y=None):
        return self

    def transform(self, X):
        X_filtered = X[(X['Hour'] >= X['TimeSunRise_first']) & (X['Hour'] <= X['TimeSunSet_first'])]
        
        return X_filtered