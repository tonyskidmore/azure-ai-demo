# pylint: disable=invalid-name
# pylint: disable=non-ascii-file-name
""" Azure Cognitive Services Translate """

import json
import os
import urllib.parse
import uuid

import requests
import streamlit as st


def call_endpoint(api_config, language, text, debug):
    """Call Azure Endpoint"""

    url = api_config["url"]
    key = api_config["key"]
    region = api_config["region"]

    params = {"api-version": "3.0", "from": "en", "to": [language]}

    headers = {
        "Ocp-Apim-Subscription-Key": key,
        # location required if you're using a multi-service or
        # regional (not global) resource.
        "Ocp-Apim-Subscription-Region": region,
        "Content-type": "application/json",
        "X-ClientTraceId": str(uuid.uuid4()),
    }

    # You can pass more than one object in body.
    body = [{"text": text}]

    try:
        data = None
        response = requests.post(
            url=url,
            params=params,
            headers=headers,
            json=body,
            verify=False,
            timeout=10,
        )

        if debug:
            st.write(response)
            st.write(dir(response))
            st.write(response.headers)
            st.write(response.headers.get("Content-Type"))
            st.write(response.json())

        response.raise_for_status()
        content_type = response.headers.get("Content-Type")
        if "application/json" in content_type:
            data = response.json()
        else:
            raise ValueError("The response is not in JSON format.")
    except requests.exceptions.Timeout:
        st.error("The request timed out.")
    except requests.exceptions.ConnectionError:
        st.error("Please check your internet connection.")
    except requests.exceptions.HTTPError as err:
        st.error("Http Error: " + str(err))
    except requests.exceptions.RequestException as err:
        st.error("Something went wrong: " + str(err))

    if data is None:
        # handle error case where data is not returned
        return None

    return data


def translate_text(text, language, debug):
    """Translate using Cognitive Services Translator"""

    try:
        # Get Configuration Settings
        # key = os.getenv('COG_SERVICE_KEY')
        # region = os.getenv('COG_SERVICE_REGION')
        endpoint = os.getenv("COG_SERVICE_ENDPOINT")
        api_config = {
            "key": os.getenv("COG_SERVICE_KEY"),
            "region": os.getenv("COG_SERVICE_REGION"),
        }
    except ValueError as ex:
        st.exception(ex)

    # if endpoint is None or key is None or region is None:
    if endpoint is None:
        st.error("COG_SERVICE_ENDPOINT environment variable not set")
        return

    if api_config["key"] is None:
        st.error("COG_SERVICE_KEY environment variable not set")
        return

    if "api.cognitive.microsofttranslator.com" in endpoint:
        path = "translate"
    else:
        path = "translator/text/v3.0/translate?api-version=3.0"

    url = urllib.parse.urljoin(endpoint, path)
    api_config["url"] = url
    if debug:
        st.write(f"endpoint: {endpoint}")
        st.write(f"path: {path}")
        st.write(f"url: {url}")

    response = call_endpoint(
        api_config=api_config, text=text, language=language, debug=debug
    )

    if response is None:
        st.error("No response from Cognitive Services")
        return

    if debug:
        st.markdown(
            json.dumps(
                response,
                sort_keys=True,
                ensure_ascii=False,
                indent=4,
                separators=(",", ": "),
            )
        )

    translation = response[0]["translations"][0]["text"]
    st.markdown(translation)


st.set_page_config(page_title="Translate Text", page_icon="🧠")

st.title("🧠 Translate Text")

st.markdown("Translate text using Azure Cognitive Services")
txt = st.text_area(
    "Text",
    "In order to perform a sequence of complicated calculations in a rapid"
    " and correct manner, it is necessary to have not only the power of"
    " directing the particular operations, but the more difficult one "
    " of arranging beforehand the exact order in which they shall"
    " succeed each other",
)
# https://learn.microsoft.com/en-us/azure/cognitive-services/translator
# /language-support
lang = st.selectbox("Language", ["de", "es", "fr", "it", "pl"])
dbg = st.checkbox("debug")
translate = st.button("Translate")
if translate:
    translate_text(txt, lang, dbg)
