import json
import os
import requests
import streamlit as st
import uuid


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
        response = requests.post(url, params=params,
                                headers=headers, json=body,
                                verify=False, timeout=10)
        response.raise_for_status()
        if response.headers.get('Content-Type') == 'application/json':
            data = request.json()
        else:
            raise ValueError("The response is not in JSON format.")
    except requests.exceptions.Timeout:
        st.error("The request timed out.")
    except requests.exceptions.ConnectionError:
        st.error("Please check your internet connection.")
    except requests.exceptions.HTTPError as err:
        st.error("Http Error:", err)
    except requests.exceptions.RequestException as err:
        st.error("Something went wrong:", err)

    return data


def translate_text(text, language, debug):
    """ Translate using Cognitive Services Translator"""

    try:
        # Get Configuration Settings
        key = os.getenv('COG_SERVICE_KEY')
        region = os.getenv('COG_SERVICE_REGION')
        endpoint = os.getenv('COG_SERVICE_ENDPOINT')
    except ValueError as ex:
        st.exception(ex)

    path = 'translator/text/v3.0/translate?api-version=3.0'
    constructed_url = endpoint + path

    response = call_endpoint(url=endpoint, text=text, key=key,
                             region=region, language=language)
    if debug:
        st.markdown(json.dumps(response, sort_keys=True,
                               ensure_ascii=False, indent=4,
                               separators=(',', ': ')))

    translation = response[0]["translations"][0]["text"]
    st.markdown(translation)

st.set_page_config(
    page_title='Translate Text',
    page_icon='🧠'
)

st.title('🧠 Translate Text')

st.markdown("Translate text using Azure Cognitive Services")
txt = st.text_input("Text", "Hello world!")
# https://learn.microsoft.com/en-us/azure/cognitive-services/translator
# /language-support
lang = st.selectbox('Language', ['de', 'es', 'fr', 'it', 'pl'])
dbg = st.checkbox('debug')
translate = st.button('Translate')
if translate:
    translate_text(txt, lang, dbg)
