# ☀️ Solar Panel Financial Results Calculator

**Authors:**  
Michał Piechota, Kacper Rodziewicz, Igor Rudolf, Gaspar Sekula

## 📜 Project Overview

This project aims to assist solar panel resellers and customers in understanding the economic benefits of solar energy investments. By leveraging a dataset of meteorological conditions and applying data preprocessing, feature engineering, and predictive modeling, we provide a user-friendly tool for estimating potential energy yield and financial savings.

Our solution focuses on simplifying complex energy data into clear, actionable insights. This empowers resellers to confidently present the financial advantages of solar power, thereby increasing customer engagement and accelerating the adoption of renewable energy solutions.

## 🗄️ Data and Preprocessing

- **Dataset**: Meteorological data from the HI-SEAS station (September–December 2016).
- **Variables**: Includes solar radiation (W/m²), temperature (°F), humidity (%), wind direction (°), wind speed (mph), and related temporal features.
- **Preprocessing Steps**:
  - Conversion of date/time features into structured temporal variables (day, month, hour).
  - Aggregation by day, month, and hour to compute mean, min, max, and standard deviation for temperature, pressure, humidity, wind speed, and direction.
  - Calculation of sunrise/sunset durations and advanced engineered features (e.g., sinusoidal transformations for time and wind direction, proportion of daylight, and various interaction terms).
  - Removal of features causing multicollinearity to ensure stable and interpretable model coefficients.

After preprocessing, the resulting dataset contains a well-defined set of predictive features, ready for modeling.

## 💡 Key Financial Parameters

- **Electricity Price**: 1.52 PLN/kWh  
- **Panel Efficiency**: 0.15–0.20  
- **Panel Area**: A = 1.7 m²  
- **Predicted Irradiance (I)**: Derived from our regression model

Using predicted irradiance, panel efficiency, and surface area, we estimate the annual energy yield and translate it into monetary savings. This makes it easier for potential buyers to weigh the long-term financial benefits of installing solar panels.

## 🤖 Modeling Approach

We explored several regression techniques to predict average solar radiation:

- **Feature Selection & Dimensionality Reduction:**  
   Used MRMR to rank features and tested top subsets (5, 10, …, 35). Additionally, applied t-tests, AIC, and BIC criteria to refine predictors, ensuring theoretical assumptions (e.g., normal residuals) for linear models were met.

- **Model Variants:**  
   Explored classical Linear Regression (with stringent assumption checks), LASSO, RIDGE, XGBoost, Neural Networks, and other regression techniques. Tuned hyperparameters extensively to optimize performance.

- **Performance Metrics & Validation:**  
   Evaluated models using R² and MRE, balancing accuracy with model complexity. The best traditional approach achieved ~0.9 R².

- **AutoML Integration:**  
   Leveraged AutoGluon for automated model selection and tuning, reaching ~0.95 R², surpassing manual optimization efforts.

The resulting model aims to provide accurate estimates of solar radiation, serving as a core input for financial calculations.

## 🚀 Getting Started

1. **Clone the repository**:  
   ```bash
   git clone https://github.com/IgorRudolf/BHL_PrymalniDualisci.git
   
