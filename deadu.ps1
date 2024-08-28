

Import-Module ActiveDirectory

$Users = Import-Csv -Delimiter "," -Path "C:\powershell\deadusers.csv"

foreach ($User in $Users)

{
$SAM = $User.deaduser
Remove-ADUser $SAM -Confirm:$false
}