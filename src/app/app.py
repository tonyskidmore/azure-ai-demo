
import altair as alt
import joblib
import math
import matplotlib.pyplot as plt
import numpy as np
import openai
import os
import pandas as pd
import streamlit as st
from collections import namedtuple
from os import environ
from utils import PrepProcesor, columns 

def predict(): 
    row = np.array([passengerid,pclass,name,sex,age,sibsp,parch,ticket,fare,cabin,embarked]) 
    X = pd.DataFrame([row], columns = columns)
    prediction = model.predict(X)
    if prediction[0] == 1: 
        st.success('Passenger Survived :thumbsup:')
    else: 
        st.error('Passenger did not Survive :thumbsdown:') 

def ask_gpt(content, role="user"):
    if os.environ.get("OPENAI_API_KEY") is not None:
        openai.api_key = os.getenv("OPENAI_API_KEY")

        completion = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": role, "content": content}
            ]
        )
        for choice in completion.choices:
          st.markdown(choice.message.content)
    else:
        st.markdown("You need to set the OPENAI_API_KEY environment variable to a valid OpenAI API key :no_entry_sign:")


st.title('Azure AI Demo App')

page = st.sidebar.selectbox('Page Navigation', ["Streamlit", "Pre-Trained ML Model", "ChatGPT", "Cognitive Services"])

st.sidebar.markdown("""---""")
st.sidebar.write("Created by [Tony Skidmore](https://www.skidmore.co.uk)")

if page == "Streamlit":
    with st.echo(code_location='below'):
        total_points = st.slider("Number of points in spiral", 1, 5000, 2000)
        num_turns = st.slider("Number of turns in spiral", 1, 100, 9)

        Point = namedtuple('Point', 'x y')
        data = []

        points_per_turn = total_points / num_turns

        for curr_point_num in range(total_points):
            curr_turn, i = divmod(curr_point_num, points_per_turn)
            angle = (curr_turn + 1) * 2 * math.pi * i / points_per_turn
            radius = curr_point_num / total_points
            x = radius * math.cos(angle)
            y = radius * math.sin(angle)
            data.append(Point(x, y))

        st.altair_chart(alt.Chart(pd.DataFrame(data), height=500, width=500)
            .mark_circle(color='#0068c9', opacity=0.5)
            .encode(x='x:Q', y='y:Q'))

if page == "Pre-Trained ML Model":
    st.markdown("Titanic survival ML model")

    model = joblib.load('xgbpipe.joblib')
    # st.title('Did they survive? :ship:')
    # PassengerId,Pclass,Name,Sex,Age,SibSp,Parch,Ticket,Fare,Cabin,Embarked
    # passengerid = st.text_input("Input Passenger ID", '123456') 
    passengerid = "123456"
    pclass = st.selectbox('Ticket class (1 = 1st, 2 = 2nd, 3 = 3rd)', [1, 2, 3])
    # name  = st.text_input("Input Passenger Name", 'John Smith')
    name = "Not Applicable"
    sex = st.selectbox('Sex', ['female', 'male'])
    age = int(st.number_input('Age:', 0, 120, 20))
    sibsp = int(st.number_input('Siblings/Spouses:', 0, 10, 0))
    parch = st.number_input("Parents:",0,2)
    # ticket = st.text_input("Input Ticket Number", "12345")
    ticket = "12345"
    fare = st.number_input("Input Fare Price", 0,1000, 50)
    cabin = st.text_input("Input Cabin", "C52") 
    embarked = st.selectbox("Did they Embark?", ['S','C','Q'])

    trigger = st.button('Predict', on_click=predict)

    st.markdown("[GitHub](https://github.com/nicknochnack/StreamlitTitanic) code")

if page == "ChatGPT":
    st.markdown("Ask questions to the OpenAI `gpt-3.5-turbo` model")
    content = st.text_input("Question", "Write me a Terraform script to create a resource group in Azure.")
    
    ask = st.button('Ask')
    if ask:
        ask_gpt(content)
