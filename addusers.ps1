
# forked from https://www.alitajran.com
# import module
Import-Module ActiveDirectory

# store the data into a var
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

    }
    catch {
        # any errors print out with username attached
        Write-Host "Failed to create user $($User.username) - $_" -ForegroundColor Red
    }
}