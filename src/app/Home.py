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
        "This is a demo application to show some examples of using "
        "elements of Artificial Intelligence(AI) in various ways "
        "within a Streamlit app."
    )

    st.markdown(
        "Navigate the sidebar to see the various examples. "
        "Start with the Streamlit menu item to learn a little more "
        "about this Python web application library."
    )


if __name__ == "__main__":
    main()


