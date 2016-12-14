# Set Environment Variables
- PRINTER_PASSWORD= 
- SECOND_PRINTER_PASSWORD=
- PRINTER_AUTH_TOKEN_KEY=
- PRINTER_AUTH_TOKEN_VALUE=
- PRINTER_UPLOAD_API_ENDPOINT=

# Set Cron
- First Visit
- Retry Visit
- Send Report

# Logs Generated
- visiting<date>.log
- visiting_retry<date>.log
- post_pp<date>.log

# Process
- Visit all printers
- Log in and download CSV reports
- Download files in respective IP folders
- Finish
- Go through again all printers
- Look for Printer Report File (Look for files with today date)
- If file not found, Visit again the printer
- Log all the visiting steps in visiting<date>.log
- Log all the retry visiting steps in visiting_retry<date>.log
- Log all the printer automation steps in debug<date>.log
- Copy the downloaded reports to User folder
- Copy the logs to User folder
- Zip the User Folder
- Send mail with zipped user folder and still missing csv reports IP in
  body
