# CHRON JOB FOR SENDING HABIT RELATED QUOTES

# Load libraries
library(tidyverse)     # workhorse package
library(googlesheets)  # for accessing google drive files
library(readxl)        # for reading in excel files
library(twilio)        # for SMS messaging

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
member_info_tbl %>% 
    
    # Get column w/member phone #s
    select(Number) %>% 
    
    # Cleanse phone numbers by removing all non-numerical values
    mutate(Number = str_replace_all(
        string = Number,
        pattern = "[^[:alnum:]]",
        replacement = ""))


 # 2.0 Pull Random Quote ----

# Read in quotes table
awesome_quotes_tbl <- read_excel("01_Data/awesome_quotes.xlsx")

# Randomly choose an awesome quote (draft stage)
awesome_quote_chr <- awesome_quotes_tbl %>% 
    select(quote) %>% 
    pull(quote) 


# 3.0 Build Message for Send ----

# 3.1 Setup Message Prefix/Suffix ----
prefix_chr <- "Weekly Quote from the App4That Group: \n\n"
suffix_chr <- "\n\nHave a Great Week and Keep up the Great Work <><"

# 3.2 Combine Pieces for SMS Message ----
message_to_group <- str_glue(
    "{prefix_chr}\"{awesome_quote_chr}\"{suffix_chr}"
    )

# 3.0 Send Quote as Text via SMS ----

# Set twilio account SID and token as environmental variables
Sys.setenv(TWILIO_SID   = Sys.getenv("my_twilio_sid"))
Sys.setenv(TWILIO_TOKEN = Sys.getenv("my_twilio_token"))

# Store the numbers in some variables
my_phone_number  <- Sys.getenv("my_phone_number")
my_twilio_number <- Sys.getenv("my_twilio_number")

# Send Message via SMS
tw_send_message(from = my_twilio_number,
                to   = my_phone_number, 
                body = message_to_group)

