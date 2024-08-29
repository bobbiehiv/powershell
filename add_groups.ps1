# same script as addusers.ps1 but added an if statement to copy group 
# membership from a template user 
# the template users samaccountname is the new users job title
# 
# .csv can contain all of the attributes in $attributes ie
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

            # Copy Users memberships from template

        if (Get-ADUser -Filter "SamAccountName -eq '$($User.jobtitle)'") {
           
	    # get template group memberships and print them to new user

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
}


# If error: "a template for <jobtitle> doesnt exist!".. a user name will still be created... 
# however you can use the following 
# Get-ADUser -Identity <UserID> -Properties memberof | Select-Object -ExpandProperty memberof |  Add-ADGroupMember -Members <New UserID>
# where <userID> is group membership you want to copy from, 
# and <new userID> is the username created without a template

