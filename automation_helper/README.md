# SetUp

## Bootstrap Download and Reports Directory
- Run set_up.rb script
  * create IP named folders in Downloads directory
  * create reports folder in home directory

## Configure Printer IP list
+ Rename config/printer_destination.yml.example as config/printer_destination.yml
+ Add IP printer and serial info to config/printer_destination.yml

## Configure GMail Info
* Rename config/smtp_info.yml.example as config/smtp_info.yml
* Put Correct Login and Password in config/smtp_info.yml

## Set Environment Variables
- Create .printer_profile file in home directory (~)
  * ~/.printer_profile
- PRIMARY_PRINTER_PASSWORD= 
- SECOND_PRINTER_PASSWORD=
- PRINTER_AUTH_TOKEN_KEY=
- PRINTER_AUTH_TOKEN_VALUE=
- PRINTER_UPLOAD_API_ENDPOINT=

## Install Chrome Driver [Mac]
- brew install chromedriver
- Create a symlink
  * sudo ln -s
    /usr/local/Cellar/chromedriver/26.0.1383.0/bin/chromedriver
/usr/bin/chromedriver

# Set Cron
- First Visit
- Retry Visit
- Send Report

# Logs Generated
- visiting<date>.log
- visiting_retry<date>.log
- post_pp<date>.log
- failure_report<date>.log


# Assumptions:
- There exists a file system where ~ responds to home directory
- There exists a directory named reports in ~

# Process

* Visiting Steps: 
  - Visit all printers
  - Log all the visiting steps in visiting<date>.log
  - Log in and download CSV reports
  - Download files in respective IP folders
  - Log all the printer automation steps in debug<date>.log
  - Finish
* Retry Visiting Steps: 
  - Go through again all printers
  - Look for Printer Report File (Look for files with today date)
  - If file not found, Visit again the printer
  - Log all the retry visiting steps in visiting_retry<date>.log
  - Log all the printer automation steps in debug<date>.log
* Post Download Steps
  - Copy the downloaded reports to User folder
  - Copy the logs to User folder
  - Create Failure Report
  - Zip the User Folder
  - Send mail with zipped user folder and still missing csv reports IP in
    body
  - Upload Printer Data to WeConnect Using API
