import pandas as pd
import streamlit as st
from streamlit.components.v1 import html



# Page config
st.set_page_config(
    page_title="Intro/Home Page",
    page_icon="inputs/sunflowerpowerIMG.jpg",
    initial_sidebar_state="expanded",
    layout="wide"
)

"""
# Garden Rooms Landscape Design

- Hi, Mom! Hopefully I can get enough functionality in this demo to narrow down this project. Looking forward to it :)
"""


#############################################
# start: sidebar
#############################################

with st.sidebar:
    
    """
    ## Select One of the Above Options
    """
    '''
    [Website Source Code (FlowerPower)](https://github.com/BrooksWalsh/Personal-Projects)

    [Template Repo/FIN-377 Final (SSLS)](https://github.com/BrooksWalsh/SSLS_dashboard)     
    '''
#############################################
# end: sidebar
#############################################

#####################################################
# Home page Stuff
#####################################################

# FILLER image of a dog
st.image("inputs/Cute_beagle.jpg", caption="Do you have... a biscuit? (Filler home page material)")
