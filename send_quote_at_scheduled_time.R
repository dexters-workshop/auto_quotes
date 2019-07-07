# CHRON JOB FOR SENDING HABIT RELATED QUOTES

# Load libraries
library(tidyverse)
library(googlesheets)
library(readxl)

# 1.0 Get Phone Numbers ----

# 1.1 Access Google Sheet ----

# Authorize 'googlesheets' to view/manage my files
gs_auth()

# Register my Google Sheet as a GS object
app4that_gs_obj <- gs_title("app4that_test")

# 1.2 Get Member Contact Info ----

# Read in member data from gs object
member_info_tbl <- app4that_gs_obj %>% 
    gs_read_csv("Member Contact Info", skip = 2)

# 1.3 Cleanse Phone # Data ----


# 2.0 Pull Random Quote ----

# Read in quotes table
awesome_quotes_tbl <- read_excel("01_Data/awesome_quotes.xlsx")

# Randomly choose an awesome quote


# 3.0 Send Quote as Text via SMS ----


