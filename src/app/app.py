""" Streamlit App """
from collections import namedtuple
import json
import math
import os
import uuid
import joblib
import altair as alt
import openai
import requests
import numpy as np
import pandas as pd
import streamlit as st
from utils import PrepProcesor, columns


def predict():
    """ Titanic model prediction """

    row = np.array([PASSENGER_ID, pclass, NAME, sex, age,
                    sibsp, parch, TICKET, fare, cabin, embarked])
    data_frame = pd.DataFrame([row], columns=columns)
    prediction = model.predict(data_frame)
    if prediction[0] == 1:
        st.success('Passenger Survived :thumbsup:')
    else:
        st.error('Passenger did not Survive :thumbsdown:')


def ask_gpt(content, role="user"):
    """ ChatGPT request """
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
        st.markdown("You need to set the OPENAI_API_KEY environment variable "
                    "to a valid OpenAI API key :no_entry_sign:")


def call_endpoint(url, language, text, key, region):
    """ Call Azure Endpoint """

    params = {
        'api-version': '3.0',
        'from': 'en',
        'to': [language]
    }

    headers = {
        'Ocp-Apim-Subscription-Key': key,
        # location required if you're using a multi-service or
        # regional (not global) resource.
        'Ocp-Apim-Subscription-Region': region,
        'Content-type': 'application/json',
        'X-ClientTraceId': str(uuid.uuid4())
    }

    # You can pass more than one object in body.
    body = [{
        'text': text
    }]

    try:
        request = requests.post(url, params=params,
                                headers=headers, json=body,
                                verify=False, timeout=10)
    except requests.exceptions.Timeout:
        st.error("The request timed out.")
    except requests.exceptions.ConnectionError:
        st.error("Please check your internet connection.")
    except requests.exceptions.HTTPError as err:
        st.error("Http Error:", err)
    except requests.exceptions.RequestException as err:
        st.error("Something went wrong:", err)

    return request.json()


def translate_text(text, language, debug):
    """ Translate using Cognitive Services Translator"""

    try:
        # Get Configuration Settings
        key = os.getenv('COG_SERVICE_KEY')
        region = os.getenv('COG_SERVICE_REGION')
        endpoint = os.getenv('COG_SERVICE_ENDPOINT')
    except ValueError as ex:
        st.exception(ex)

    # path = '/translate'
    # constructed_url = endpoint + path

    response = call_endpoint(url=endpoint, text=text, key=key,
                             region=region, language=language)
    if debug:
        st.markdown(json.dumps(response, sort_keys=True,
                               ensure_ascii=False, indent=4,
                               separators=(',', ': ')))

    translation = response[0]["translations"][0]["text"]
    st.markdown(translation)


# def main():
#     """ Main """
st.title('Azure AI Demo App')

page = st.sidebar.selectbox('Page Navigation', ["Streamlit",
                                                "Pre-Trained ML Model",
                                                "ChatGPT",
                                                "Cognitive Services"])

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

    PrepProcesor()
    model = joblib.load('xgbpipe.joblib')
    # st.title('Did they survive? :ship:')
    # PassengerId,Pclass,Name,Sex,Age,SibSp,Parch,Ticket,Fare,Cabin,Embarked
    # passengerid = st.text_input("Input Passenger ID", '123456')
    PASSENGER_ID = "123456"
    pclass = st.selectbox('Ticket class (1 = 1st, 2 = 2nd, 3 = 3rd)',
                        [1, 2, 3])
    # name  = st.text_input("Input Passenger Name", 'John Smith')
    NAME = "Not Applicable"
    sex = st.selectbox('Sex', ['female', 'male'])
    age = int(st.number_input('Age:', 0, 120, 20))
    sibsp = int(st.number_input('Siblings/Spouses:', 0, 10, 0))
    parch = st.number_input("Parents:", 0, 2)
    # ticket = st.text_input("Input Ticket Number", "12345")
    TICKET = "12345"
    fare = st.number_input("Input Fare Price", 0, 1000, 50)
    cabin = st.text_input("Input Cabin", "C52")
    embarked = st.selectbox("Where did they Embark? (Southampton, Cherbourg, "
                            "Queenstown)", ['S', 'C', 'Q'])

    trigger = st.button('Predict', on_click=predict)

    st.markdown("[GitHub](https://github.com/nicknochnack/StreamlitTitanic)"
                "code")

if page == "ChatGPT":
    st.markdown("Ask questions to the OpenAI `gpt-3.5-turbo` model")
    text_input = st.text_input("Question", "What is Streamlit?")

    ask = st.button('Ask')
    if ask:
        ask_gpt(text_input)

if page == "Cognitive Services":
    st.markdown("Translate text using Azure Cognitive Services")
    txt = st.text_input("Text", "Hello world!")
    # https://learn.microsoft.com/en-us/azure/cognitive-services/translator
    # /language-support
    lang = st.selectbox('Language', ['de', 'es', 'fr', 'it', 'pl'])
    dbg = st.checkbox('debug')
    translate = st.button('Translate')
    if translate:
        translate_text(txt, lang, dbg)


# if __name__ == "__main__":
#    main()
