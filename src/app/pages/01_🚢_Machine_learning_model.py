# pylint: disable=invalid-name
# pylint: disable=non-ascii-file-name
# pylint: disable=pointless-string-statement
""" Titanic survival model """

import joblib
import pandas as pd
import streamlit as st

st.set_page_config(page_title="Titanic Survival Model", page_icon="🚢")

st.title("🚢 Titanic Survival ML Model")

st.markdown(
    "[RMS Titanic](https://en.wikipedia.org/wiki/Titanic) was a British "
    " passenger liner that sank in the "
    "North Atlantic Ocean on 15 April 1912 after striking an iceberg "
    "during her maiden voyage."
)

"""
Titanic's passengers numbered approximately 1,317 people:

* 324 in First Class
* 284 in Second Class
* 709 in Third Class

Of these, 869 (66%) were male and 447 (34%) female  .
Women and children survived at rates of about 75 percent and
50 percent, while only 20 percent of men survived.
"""

st.markdown(
    "**:red[706]** people survived the disaster and "
    "**:red[1,517]** people died."
)

st.markdown(
    "This example uses a pre-built model, stored on this application "
    "container image, and is used to predict if a passenger is likely to "
    "have survived the Titanic disaster based on the details entered in the "
    "form below."
)

st.markdown(
    "It is an example of using a pre-built machine learning model "
    "within a Streamlit app."
)

st.markdown(
    "Visit "
    "[titanic-ml-model](https://github.com/tonyskidmore/titanic-ml-model) "
    "to find out how the model was created."
)


def predict(data_frame):
    """Titanic model prediction"""

    prediction = model.predict(data_frame)
    if prediction[0] == 1:
        st.success("Passenger Survived :thumbsup:")
    else:
        st.error("Passenger did not Survive :thumbsdown:")


model = joblib.load('model.joblib')

location_mapping = {
    "Southampton": [1, 0, 0],
    "Cherbourg": [0, 1, 0],
    "Queenstown": [0, 0, 1],
}

sex_mapping = {
    "male": [0, 1],
    "female": [1, 0],
}

# not applicable data but required for model
passenger_id = "123456"
pclass = int(st.selectbox("Class:", ["1", "2", "3"], index=2))
sex = st.selectbox("Sex", ["male", "female"])
age = int(st.number_input("Age:", 0, 55, 30))
sibsp = int(st.number_input("Siblings/Spouses:", 0, 10, 0))
parch = st.number_input("Parents:", 0, 2)
fare = st.number_input("Input Fare Price", 5, 515, 30)
embarked = st.selectbox(
    "Where did they Embark?",
    ["Southampton", "Cherbourg", "Queenstown"],
)

female, male = sex_mapping.get(sex, [0, 0])
southampton, cherbourg, queenstown = location_mapping.get(embarked, [0, 0, 0])

data = pd.DataFrame({
    'PassengerId': [passenger_id],
    'Pclass': [pclass],
    'Age': [age],
    'SibSp': [sibsp],
    'Parch': [parch],
    'Fare': [fare],
    'Sex_female': [female],
    'Sex_male': [male],
    'Embarked_C': [cherbourg],
    'Embarked_Q': [queenstown],
    'Embarked_S': [southampton],
})

# debugging
# st.markdown(data.head())

if st.button("Predict"):
    predict(data)
