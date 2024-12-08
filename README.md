# ☀️ Solar Radiation Prediction Project

Welcome to our Solar Radiation Prediction project! This repository contains the implementation of data preprocessing, feature engineering, and modeling to predict solar radiation using meteorological data. 🌤️

## 📋 Table of Contents
- 🎯 **Business Objective**
- 📊 **Dataset**
- 🛠️ **Preprocessing & Feature Engineering**
- 🤖 **Models**
- 📈 **Results**
- 📝 **Conclusions**

---

## 🎯 Business Objective
Our goal is to assist solar panel resellers in reaching more clients by predicting solar radiation efficiently, emphasizing the financial benefits of solar energy. 💡

---

## 📊 Dataset
We used meteorological data collected from the HI-SEAS weather station during September to December 2016. Key features include:
- **Solar radiation** (target variable, W/m²)
- **Temperature**, **Humidity**, **Wind Speed**, **Pressure**
- **Sunrise** and **Sunset times**

---

## 🛠️ Preprocessing & Feature Engineering
### Preprocessing Steps:
1. 🗓️ **Date Features**: Extracted `Day`, `Month`, and `Hour` from datetime columns.
2. 🌅 **Sunlight Features**: Calculated `SunDurationMinutes` (sunrise to sunset duration).
3. 📊 **Aggregation**: Grouped by `Day`, `Month`, and `Hour` and computed:
   - Mean, min, max, std for **Temperature**, **Pressure**, **Humidity**, **Wind Speed**
   - Mean solar radiation (target)
4. 🔍 **Redundant Columns**: Removed unnecessary columns (`UNIXTime`).

### Feature Engineering Highlights:
- 📈 **Proportion of Day**: `(Hour - TimeSunRise) / (TimeSunSet - TimeSunRise)`
- 🌡️ **Temperature Amplitude**: `Temperature_max - Temperature_min`
- 🌬️ **Wind Energy**: `Speed_mean^2`
- 🔄 **Cyclic Features**: Applied sinusoidal transformations (`Hour`, `Wind Direction`).
- 🌤️ **Time to Noon**: Captured solar noon proximity.

---

## 🤖 Models
We implemented and evaluated linear regression models using:
- 🚀 **Feature Selection**: Used AIC/BIC criteria for optimal predictors.
- 📉 **Residual Analysis**: Diagnosed and addressed model assumptions (e.g., linearity, homoscedasticity).
- 🔧 **Weighted Regression**: Applied WLS to handle heteroskedasticity.

---

## 📈 Results
Our optimized model predicts solar radiation accurately, and the engineered features significantly improve performance. Detailed results and visualizations are available in the report. 📊

---

## 📝 Conclusions
This project demonstrates how feature engineering and thoughtful preprocessing can enhance predictive modeling for solar radiation, supporting informed decisions for solar energy applications. 🌍

---

## 💾 How to Run
1. Clone the repo:
   ```bash
   git clone https://github.com/your-repo-name.git
   cd your-repo-name
