import pandas as pd
import numpy as np
import streamlit as st


st.set_page_config(
    page_title="Input/Creation",
    page_icon="inputs/sunflowerpowerIMG.jpg",
    initial_sidebar_state="expanded",
    layout="wide"
)

#####################################################
# Sidebar
#####################################################


# choose current project Selectbox (Walsh_D, Walsh_J, Blaney_C)
# choose project version Selectbox (v1,v2,v3,etc.)


# remove an existing entry Selectbox (*see final section?)
#   - creates a bunch of checkboxes, one for each plant


# add new entry Button (*see final section?)
#   - pop-up (or subpage) that allows manual entry of new plant data
#       - Drag+Drop Picture
#       - Text input for names, description, etc.
#       - after creation, choose to add to current project.


# create new project Button
#   - button functionality detailed below


# lame horizontal line
st.markdown('<hr style="border-top: 2px solid #bbb;">', unsafe_allow_html=True)


# export new project as .docx

#####################################################
# Data Input
#####################################################

#####################
# Create new Project
#####################

# Start creation process by pressing aforementioned button, which makes a pop-up (or sub-page)


# Drag and drop input dataframe as .csv (figure out file format later, csv pref)


# use dataframe to grab index indentifiers for each plant in project


# check to see how many of those identifiers are in the pre-existing database


# if icon is not, prompt to make new icons for those ID's. Grab + match icons to ID's
#   - prompt to make new icon will be the same as for "add new entry Button"


# After all ID's have attached icon information, create a full document.
#   - document can be accessed using "choose current project" selectbox


##################
# Amend a Project or view a new creation
##################

# select a previously made project using the sidebar (includes recent creations)


# it will display the input dataframe and resulting word document


###
# this section may include the functionality for amending/deleting icons to/from old projects
###


