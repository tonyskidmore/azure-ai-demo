# pylint: disable=invalid-name
# pylint: disable=non-ascii-file-name
""" ChatGPT example """

import os

import openai
import streamlit as st


def ask_gpt(content, role="user"):
    """ChatGPT request"""
    if os.environ.get("OPENAI_API_KEY") is not None:
        openai.api_key = os.getenv("OPENAI_API_KEY")

        completion = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[{"role": role, "content": content}],
        )
        for choice in completion.choices:
            st.markdown(choice.message.content)
    else:
        st.markdown(
            "You need to set the OPENAI_API_KEY environment variable "
            "to a valid OpenAI API key :no_entry_sign:"
        )


st.set_page_config(page_title="Ask ChatGPT", page_icon="🙊")

st.title("🙊 Ask ChatGPT")

st.markdown("Ask questions to the OpenAI `gpt-3.5-turbo` model")
text_input = st.text_input("Question", "Write a Haiku about GitOps")

ask = st.button("Ask")
if ask:
    ask_gpt(text_input)
