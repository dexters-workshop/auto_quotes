# CHRON JOB FOR SENDING HABIT RELATED QUOTES

# 0.0 HIGH-LEVEL SCRIPT OVERVIEW ----
# 1) Pulls Member Contact Details from Google Sheets
# 2) Selects Habit Related Quote from table
# 3) Builds Message for SMS as Text
# 4) Sends SMS Quote/Message to each Group Member
        # Planning to have a Mon messsage + Fri message
        # Once i get further along in setting cron-job

# Load libraries
library(tidyverse)     # workhorse package
library(googlesheets)  # for accessing google drive files
library(readxl)        # for reading in excel files
library(twilio)        # interface to Twilio API for R
library(cronR)         # for managing cron jobs
library(lubridate)     # for working with dates


# Variable for Controlling which message to send
wk_day_chr <- wday(today(), label = T, abbr = F)
    # this will be for chron-job later on (alpha-stage)
    # SMS messages will go out Mon + Fri
    # Pulling day from today() will allow for controlling  script flow:
        # which message to send: week or weekend message.

# 1.0 Get Member Phone Numbers ----

# 1.1 Access Google Sheet ----

# Authorize 'googlesheets' to view/manage my files
gs_auth()

# Register my Google Sheet as a GS object
app4that_gs_obj <- gs_title("app4that_test")
#app4that_gs_obj <- gs_title("app4that")

# 1.2 Get Member Contact Info ----

# Read in member data from gs object
member_info_tbl <- app4that_gs_obj %>% 
    
    # Specify worksheet to pull data from
    gs_read_csv(ws = "Member Contact Info", 
                skip = 2)

# 1.3 Cleanse Phone # Data ----

# Clean up Phone # Data
cleaned_phone_numbers_tbl <- member_info_tbl %>% 
    
    # Get column w/member phone #s
    select(Number) %>% 
    
    # Cleanse phone #s - remove non-numerical values
    mutate(Number = str_replace_all(
        string = Number,
        pattern = "[^[:alnum:]]",
        replacement = "")) %>% 
    
    # Convert phone #s from character to numeric
    mutate_if(is.character, as.numeric) 

# Save Phone #s in List
cleaned_phone_numbers_list <- cleaned_phone_numbers_tbl %>%
    pull(Number)


 # 2.0 Pull Random Quote ----

# Read in quotes table
awesome_quotes_tbl <- read_excel("01_Data/awesome_quotes.xlsx")

# Randomly choose an awesome quote (draft stage)
awesome_quote_chr <- awesome_quotes_tbl %>% 
    
    # Select Random Row in Quotes Table
    sample_n(size = 1) %>% 
    
    # Select Quote + Author and combine them in new column
    select(quote, author) %>% 
    mutate(quote_with_author = str_glue(
        "\"{quote}\" - {author}"
    )) %>% 
    select(quote_with_author) %>% 
    pull(quote_with_author)


# 3.0 Build Message for Send ----

# 3.1 Setup Message Prefix/Suffix ----

# Setup Monday Message Prefix/Suffix
prefix_mon_chr <- "BETA-TESTING\n\nWeekly Quote from the App4That Group: \n\n"
suffix_mon_chr <- "\n\nHave a Great Week <><"

# Setup Friday Message Prefix/Suffix
prefix_fri_chr <- "BETA-TESTING\n\nHappy Friday App4That Group Members: \n\n"
suffix_fri_chr <- "\n\nHave an Awesome Weekend <><"

# 3.2 Combine Pieces for SMS Message ----

# Build Monday Message
message_to_group <- str_glue(
    "{prefix_fri_chr}{awesome_quote_chr}{suffix_fri_chr}")

# Build Friday Message
message_to_group <- str_glue(
    "{prefix_fri_chr}{awesome_quote_chr}{suffix_fri_chr}")

# 4.0 Send Quote as Text via SMS ----

# Set twilio account SID and token as environmental variables
Sys.setenv(TWILIO_SID   = Sys.getenv("my_twilio_sid"))
Sys.setenv(TWILIO_TOKEN = Sys.getenv("my_twilio_token"))

# Store the numbers in some variables
my_phone_number  <- Sys.getenv("my_phone_number")
my_twilio_number <- Sys.getenv("my_twilio_number")

# Send Message via SMS

# Loop to Send Each Member the Message
for (member in 1:length(cleaned_phone_numbers_list)) {
    
    # Loop over Member phone #s and send Message
    tw_send_message(from = my_twilio_number,
                    to   = cleaned_phone_numbers_list[member], 
                    body = message_to_group)
}
