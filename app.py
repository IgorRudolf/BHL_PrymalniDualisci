import streamlit as st
import pandas as pd
import joblib

st.title("Solar Money Calculator")

uploaded_file = st.file_uploader("Upload a file with measurements", type=["csv"])


# processing_pipeline = joblib.load('data/processed_data/processing_pipeline.joblib')
# fe_pipeline = joblib.load('data/processed_data/fe_pipeline.joblib')
# model = joblib.load('model_final/model_final.joblib')

weights = [5.1, 5.5, 6.1, 6.2, 
           6.4, 7.2, 7.0, 6.7, 
           6.5, 6.0, 5.7, 5.5]

def sun_predict(sum_output_model, month):
    total = 0
    base = sum_output_model * 30 / 7
    for i in range(12):
        if i + 1 != month:
            total += base * weights[i] / weights[month - 1]
        else:
            total += base
    return total


# sum_output_model = model.predict(uploaded_file)
sum_output_model = 1000 # temporary
month = 3 # temporary
total_radiation = sun_predict(sum_output_model, month)


price = st.number_input("Enter the price of 1KWh", min_value=0.0, step=0.01)
number_of_panels = st.number_input("Enter the number of panels", min_value=0, step=1)
efficiency = st.slider("Select efficiency", min_value=1, max_value=100, value=50)
area = st.number_input("Enter the area of one panel", min_value=0.0, step=0.01)
total_production = total_radiation * area * efficiency

if st.button('Predict'):
    st.header(f"Predicted yearly solar energy production: {round(total_production / 1000, 3)} KWh")
    st.header(f"Predicted yearly savings: {round(total_production * price / 1000, 3)} zł")
