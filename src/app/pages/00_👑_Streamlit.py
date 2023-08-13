# pylint: disable=invalid-name
""" Homepage Streamlit app """

import math
from collections import namedtuple

# from streamlit_extras.switch_page_button import switch_page
import altair as alt
import pandas as pd
import streamlit as st


def main():
    """Main"""

    st.set_page_config(
        layout="centered", page_title="Streamlit", page_icon="👑"
    )

    # @st.cache_data
    # def icon(emoji: str):
    #     """Shows an emoji as a Notion-style page icon."""
    #     st.write(
    #         f'<span style="font-size: 78px; line-height: 1">{emoji}</span>',
    #         unsafe_allow_html=True,
    #     )

    # icon(":crown:")
    st.title("Streamlit")

    st.markdown(
        "Streamlit is an open-source Python library that makes it easy to"
        " build beautiful and interactive web applications for"
        " machine learning and data science."
    )

    st.markdown(
        "It is designed to simplify"
        " the process of creating data-centric applications by providing"
        " an easy-to-use and intuitive interface for building and deploying"
        " web applications without needing any web development experience."
    )

    st.markdown(
        "With Streamlit, developers can create custom apps and visualizations"
        " with just a few lines of Python code and quickly iterate on their"
        " ideas. It also provides a variety of pre-built components like"
        " forms, tables, and charts, to create engaging user interfaces."
    )

    st.markdown("For example, like this:")

    with st.echo(code_location="below"):
        total_points = st.slider("Number of points in spiral", 1, 5000, 2000)
        num_turns = st.slider("Number of turns in spiral", 1, 100, 9)

        Point = namedtuple("Point", "x y")
        data = []

        points_per_turn = total_points / num_turns

        for curr_point_num in range(total_points):
            curr_turn, i = divmod(curr_point_num, points_per_turn)
            angle = (curr_turn + 1) * 2 * math.pi * i / points_per_turn
            radius = curr_point_num / total_points
            x = radius * math.cos(angle)
            y = radius * math.sin(angle)
            data.append(Point(x, y))

        st.altair_chart(
            alt.Chart(pd.DataFrame(data), height=500, width=500)
            .mark_circle(color="#0068c9", opacity=0.5)
            .encode(x="x:Q", y="y:Q")
        )


if __name__ == "__main__":
    main()
