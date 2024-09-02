
# define email varibles 
# needed to add 2factorAuth and app password in gmail

$myEmail = "bobbiehiv@gmail.com"
$creds = (Get-Credential -Credential $myEmail)
$SMTP = "smtp.gmail.com"     # check $PSemailserver
$To = "receiver@email.com"   # random email
$subject = "credentials for $($User.fname) $($User.lname)"
$port = 587
# create a template and add credentials 
$body = " " 

start-sleep 2 
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
