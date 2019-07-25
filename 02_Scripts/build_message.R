# FUNCTION FOR COMBINING PARTS TO BUILD MESSAGE

# Load Libraries
library(tidyverse)

# Function for Building Monday OR Friday messages
build_message <- function(day_of_week) {
    
    # If not Monday OR Friday, stop script entirely
    if (!day_of_week %in% c("mon", "fri")) {
        stop("Day of week is outside the normal SMS send day.")
        
    # If Monday, Build Monday Message
    } else if (day_of_week == "mon") {
        
        # Setup Monday Message Prefix/Suffix
        prefix_mon_chr <- "Weekly Quote from the App4That Group: \n\n"
        suffix_mon_chr <- "\n\nHave a Great Week <><"
        
        # Build Monday Message
        message_to_group <- str_glue(
            "{prefix_mon_chr}{awesome_quote_chr}{suffix_mon_chr}")
        
    # If Friday, Build Friday Message   
    } else if (day_of_week == "fri") {
        
        # Setup Friday Message Prefix/Suffix
        prefix_fri_chr <- "Happy Friday App4That Group Members: \n\n"
        suffix_fri_chr <- "\n\nHave an Awesome Weekend <><"
        
        # Build Friday Message
        message_to_group <- str_glue(
            "{prefix_fri_chr}{awesome_quote_chr}{suffix_fri_chr}")
        
    # If alt. problem, halt + give error message
    } else {
        stop("Unknown problem, script halted")
    } 
    
    # Return message for SMS
    return(message_to_group)
    
}
