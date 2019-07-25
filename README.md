# ☎️ auto_quotes ☎️

Automated delivery service that pulls member-contact info from google-sheets, then sends awesome quotes via SMS/Twilio.

This is a project I did as part of a meetup group that I'm involved with (called App4That). The group is focused on building new healthy habits using the 'mini-habit' framework. I was adding really cool quotes related to 'habit-formation' to our google sheet each week - so that members could see them while tracking their daily habits.

I wanted to automate the process and have awesome quotes (+ general messages) sent via text message and that's how this project got started.

The idea is simple: 

📌 Access member contact info from our Google Sheet.  
📌 Pull/Cleanse Phone data using reg-ex, tidyverse.  
📌 Build a small database (DB) of quotes.  
📌 Grab an awesome 'habit quote' from DB.  
📌 Build Message by Combining Parts: prefix/quote/suffix
📌 Us  e SMS to text the group a cool message w/an awesome quote!
📌 Set   up on an automated schedule (in the works).    

Thiwas the first quote to the group: 

"Be the person with embarrassing goals and impressive results instead of one of the many people with impressive goals and embarrassing results" - Step  
en Guise

Feel frto Sean Kross for building the Twilio package for R:

☎️ An   nterface to the Twilio API for R