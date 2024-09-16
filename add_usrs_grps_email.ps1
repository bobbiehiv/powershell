
# script to add bulk users with a .csv file into AD
# added portion at the end to auto send an email, after entering credentials
# set up for gmail, may need to adjust for other servers
# also added pin section to csv
# csv can contain all of the attributes in $attributes ie
# attribute = $User.username,fname,lname,initials,description,office,etc

# import module
Import-Module ActiveDirectory

# store the data 
$newguys = Import-Csv -Path C:\powershell\adduser.csv

$username = $User.username

# Define the user Principal name
$PN = "nomain.com"

foreach ($User in $newguys) {
    try { 
        # define attributes with a hashtable
        $attributes = @{
            sAMAccountName        = $User.username
            userPrincipalName     = "$($User.username)@$PN" 
            name                  = "$($User.fname) $($User.lname)"
            givenName             = $User.fname
            surname               = $User.lname
            initials              = $User.initials
            Enabled               = $True
            DisplayName           = "$($User.fname) $($User.lname)"
            Description           = $user.description
            Office                = $User.office
            Path                  = $User.OU
            Company               = $User.company
            OfficePhone           = $User.phone
            EmailAddress          = $User.email
            Title                 = $User.jobtitle
            Department            = $User.department
            AccountPassword       = (ConvertTo-SecureString $User.password -AsPlainText -Force)
            ChangePasswordAtLogon = $True
        }

        # see it the user already exists in AD
        if (Get-ADUser -Filter "SamAccountName -eq '$($User.username)'") {
            # send out a warning
            Write-Host "A user with username $($User.username) already exists!" -ForegroundColor Red
        }
        else {
            New-ADUser @attributes
            # add the user and let you know
            Write-Host "The user $($User.username) is created." -ForegroundColor Green
        }

            # Copy Users memberships from to another 

        if (Get-ADUser -Filter "SamAccountName -eq '$($User.jobtitle)'") {
            # get user group memberships
    
            # print them to new user
            Get-ADUser -Identity $user.jobtitle -Properties memberof | Select-Object -ExpandProperty memberof |  Add-ADGroupMember -Members $user.username
            }
        else {

        Write-Host  "A template for $($User.jobtitle) doesnt exist!" -ForegroundColor Red

           }


    }
    catch {
        # any errors print out with username attached
        Write-Host "Failed to create user $($User.username) - $_" -ForegroundColor Red
    }

# define email varibles 
# needed to add 2factorAuth and app password in gmail

$myEmail = "bobbiehiv@gmail.com"
$creds = (Get-Credential -Credential $myEmail)
$SMTP = "smtp.gmail.com"     # check for $PSemailserver 
$To = "receiver@nothing.fake"   # not reall email
$subject = "credentials for $($User.fname) $($User.lname)"
$port = 587                  # create a template and add credentials 
$body = "                    

Hey User, 

Below are user credentials for $($User.fname).

Username:  $($User.username)

initial password: $($User.password)

Email:  $($User.username)@$PN

Pin:  $($User.pin)

(Meditech password will be the password created from initial password change )

If you have any questions or issues, please contact our helpdesk at (215) 555-555 or email helpdesk@HIV.org.

Thanks,

Robert Houston
IS Technical Services
bobbiehiv@gmail.com
Phone:(215) 555-555 Fax:(215) 555-555"

# start-sleep 2              # sleep for two seconds before running 
                           # the command
Send-MailMessage -To $To -From $myEmail -Subject $subject -Body $body -SmtpServer $SMTP -Credential $creds -UseSsl -Port $port -DeliveryNotificationOption Onsuccess

<#
delivery notification options: 
None - no notifications 
Onsuccess - notifiy if successful 
onfailure - notify is failure 
Delay - notify if delayed 
Never - never 
#>

}

