# auto_quotes

Automated delivery service for habit-related quotes via SMS and member-contact info pulled from google-sheets.

This is a project I'm working on as part of a meetup group that I'm involved with.

The group is focused on building new healthy habits using the 'mini-habit' framework.

I was adding really cool quotes related to 'habit-formation' to our google sheet each week - so that members could see them while trakcing their daily habits.

I wanted to automate the process and have awesome quotes sent via text message and that's how this project got started.

THE IDEA AND WHERE I'M HEADED
I'm creating a chron-job to pull habit-related quotes from a database I'm building. The idea is simple: 
📌 Access member info from our Google Sheet.
📌 Pull/Cleanse Phone data using reg-ex, tidyverse.
📌 Build a small database (DB) of quotes.
📌 Grab an awesome 'habit quote' from DB.
📌 Use SMS to text the group a Sweet quote.
📌 Set up on an automated schedule (chron-job)

I'm thinking of this as the first quote: 
"be the person with embarrassing goals and impressive results instead of one of the many people with impressive goals and embarrassing results"