
# define email varibles 
# needed to add 2factorAuth and app password for gmail

$myEmail = "bobbiehiv@gmail.com"
$creds = (Get-Credential -Credential $myEmail)
$SMTP = "smtp.gmail.com"     # check for $PSemailserver
$To = "receiver@email.com"   # random email
$subject = ""                # create the subject
$port = 587                  # SMTP port
$body = ""                   # create the body 

start-sleep 2                # will sleep for 2 seconds before running
# the actual command
Send-MailMessage -To $To -From $myEmail -Subject $subject -Body $body -SmtpServer $SMTP -Credential $creds -UseSsl -Port $port -DeliveryNotificationOption Onsuccess

<#
delivery notification options: 
None - no notifications 
Onsuccess - notifiy if successful 
onfailure - notify is failure 
Delay - notify if delayed 
Never - never 
#>
