import joblib
import streamlit as st
import numpy as np
import pandas as pd
import streamlit as st
from utils import PrepProcesor, columns

st.set_page_config(
    page_title='Titanic Survival Model',
    page_icon='🚢'
)

st.title('🚢 Titanic Survival ML Model')


# st.info("`ExperimentalBaseConnection` makes it easy to build, use and share your own connection implementations.", icon="💡")

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

# st.markdown("Titanic survival ML model")

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

st.markdown("[GitHub](https://github.com/nicknochnack/StreamlitTitanic) "
            "code")
