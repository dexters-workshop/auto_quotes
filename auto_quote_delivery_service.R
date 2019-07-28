# AUTOMATED SMS AS TEXT BY PULLING CONTACT INFO FROM GOOGLE-SHEETS

# 0.0 HIGH-LEVEL SCRIPT OVERVIEW ----
    # 1.0 Pulls Member Contact Details from Google Sheets
    # 2.0 Selects Habit/Systems Related Quote from data-table
    # 3.0 Builds Message for SMS Send
    # 4.0 Send SMS Message/Quote to each Group Member

# 0.1 CURRENT SETUP ----

# Sends a Monday + Friday Message to Group

# Load libraries
library(tidyverse)     # workhorse package
library(googlesheets)  # for accessing google drive files
library(readxl)        # for reading in excel files
library(twilio)        # interface to Twilio API for R
library(cronR)         # for managing cron jobs
library(lubridate)     # for working with dates


# 1.0 Get Member Phone Numbers ----

# 1.1 Access Google Sheet ----

# Authorize 'googlesheets' to view/manage my files
gs_auth()

# Register my Google Sheet as a GS object
app4that_gs_obj <- gs_title("app4that")
#app4that_gs_obj <- gs_title("app4that")

# 1.2 Get Member Contact Info ----

# Read in member data from gs object
member_info_tbl <- app4that_gs_obj %>% 
    
    # Specify worksheet to pull data from
    gs_read_csv(ws   = "Member Contact Info", 
                skip = 2)

# 1.3 Cleanse Phone # Data ----

# Clean up Member Phone # Data
cleaned_phone_numbers_tbl <- member_info_tbl %>% 
    
    # Get column w/member phone #s
    select(Number) %>% 
    
    # Cleanse phone #s in 'Number' Column: Remove non-numerical characters
    mutate(Number = str_replace_all(
            string      = Number,
            pattern     = "[^[:alnum:]]",
            replacement = "")
           ) %>% 
    
    # Convert phone #s from character to numeric
    mutate_if(is.character, as.numeric) 

# Pull + Save Phone #s in List
cleaned_phone_numbers_list <- cleaned_phone_numbers_tbl %>%
    pull(Number)


# 2.0 Pull Random Quote ----

# Read in quotes table
awesome_quotes_tbl <- read_excel("01_Data/awesome_quotes.xlsx")

# 2.1 Get + Format Quote ----

# Randomly Select Awesome Quote + Prep for SMS
awesome_quote_chr <- awesome_quotes_tbl %>% 
    
    # Select Random Row in Quotes Data-Table
    sample_n(size = 1) %>% 
    
    # Select Quote + Author Columns
    select(quote, author) %>% 
    
    # Formatting: combine quote then author
    mutate(quote_with_author = str_glue(
        "\"{quote}\" - {author}"
    )) %>% 
    
    # Select + Pull formatted quote as character/string
    select(quote_with_author) %>% 
    pull(quote_with_author)


# 3.0 Build Message for Send ----

# For now, we are sending a Monday + Friday message

# 3.1 Controlling flow w/Weekday Variable ----

# Pull weekday from today()
wk_day_chr <- wday(today(), label = TRUE) %>% str_to_lower()
# wk_day_chr <- "mon"    # uncomment for testing


# 3.2 Source Function + Build Message ----

# Source function from build_message.R
source("02_Scripts/build_message.R")

# Call function + build message
message_to_group <- build_message(wk_day_chr)


# 4.0 Send Quote as Text via SMS ----

# 4.1 Get + Set Environmental Variables ----

# Set twilio account SID and token as environmental variables
Sys.setenv(TWILIO_SID   = Sys.getenv("my_twilio_sid"))
Sys.setenv(TWILIO_TOKEN = Sys.getenv("my_twilio_token"))

# Store the numbers in some variables
my_twilio_number <- Sys.getenv("my_twilio_number")
# my_phone_number  <- Sys.getenv("my_phone_number")


# 4.2 Utilzie Twilio to Send Message via SMS ----

# Iteration Method 01: Iterate using Purr + map()

# Use anonymous function that iterates over # list
cleaned_phone_numbers_list %>% 
    
    # Call twilio function to send message
    map(~ tw_send_message(
        from = my_twilio_number,
        to   = ., 
        body = message_to_group
    ))


# Iteration Method 02: Iterate using a base-R for-loop

# Use for-Loop to iterate over Member phone # list
for (member in 1:length(cleaned_phone_numbers_list)) {
    
    # Call twilio function to send message
    tw_send_message(from = my_twilio_number,
                    to   = cleaned_phone_numbers_list[member], 
                    body = message_to_group)
}
