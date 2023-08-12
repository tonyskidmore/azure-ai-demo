# pylint: disable=invalid-name
""" Homepage Streamlit app """

# import math
# from collections import namedtuple

# from streamlit_extras.switch_page_button import switch_page
# import altair as alt
# import pandas as pd
import streamlit as st


def main():
    """Main"""

    st.set_page_config(
        layout="centered", page_title="Azure AI Demo App", page_icon="👑"
    )

    @st.cache_data
    def icon(emoji: str):
        """Shows an emoji as a Notion-style page icon."""
        st.write(
            f'<span style="font-size: 78px; line-height: 1">{emoji}</span>',
            unsafe_allow_html=True,
        )

    icon(":crown:")
    st.title("Azure AI Demo App")

    st.markdown(
        "Application to show examples of using AI related capabilities."
    )

    # st.markdown(
    #     "It is designed to simplify"
    #     " the process of creating data-centric applications by providing"
    #     " an easy-to-use and intuitive interface for building and deploying"
    #     " web applications without needing any web development experience."
    # )

    # st.markdown(
    #     "With Streamlit, developers can create custom apps and visualizations"
    #     " with just a few lines of Python code and quickly iterate on their"
    #     " ideas. It also provides a variety of pre-built components like"
    #     " forms, tables, and charts, to create engaging user interfaces."
    # )



if __name__ == "__main__":
    main()


