
# script for removing users in bulk
# use a .csv file where the deader is deaduser

Import-Module ActiveDirectory

$Users = Import-Csv -Delimiter "," -Path "C:\powershell\deadusers.csv"

foreach ($User in $Users)

{
$SAM = $User.deaduser
Remove-ADUser $SAM -Confirm:$false
}