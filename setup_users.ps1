# Usage
#
# Create users for Ansible training
#
# using native azure ad users
#
# Author: Jesper Berth, jesper.berth@arrow.com - july 2020

function run{

    write-host "Create new users for Azure DevOps Class`n"

    $numberUsers = Read-Host "Number of users"
    $defaultPassword = Read-host "Enter default password for new users"

    createUsers $numberUsers $defaultPassword


}

function createUsers($numberUsers, $defaultPassword) {

    write-host "`nCreating $numberUsers new users`n"
    write-host -foregroundcolor yellow "with default password: $defaultPassword`n"
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $defaultPassword
    $domain = get-azureaddomain | where-object {$_.IsDefault -eq $true} | select-object Name
    $domainname = $domain.name

    for($i=1; $i -le $numberUsers; $i++ ){
        $user = "devopsuser$i"
        #write-host $user
        $upn = $user+"@"+$domainname
        write-host "Create user: $upn"
        try{
        New-AzureADUser -DisplayName $user -PasswordProfile $PasswordProfile -UserPrincipalName $upn -AccountEnabled $true -MailNickName $user
        roleAssignment $user
        }
        catch{
            write-host -ForegroundColor yellow "$upn already exists"
        }
    }
}

function roleAssignment($user) {
    $userguid = (Get-AzureADUser -Filter "DisplayName eq '$user'").ObjectId

    New-AzureRmRoleAssignment -ObjectId $userguid -RoleDefinitionName Owner -Scope "/subscriptions/$subId"

    $role = (Get-AzureADDirectoryRole | Where-Object {$_.displayName -eq 'Application administrator'}).ObjectId

    Add-AzureADDirectoryRoleMember -ObjectId $role -RefObjectId $userguid
    }
#connect-azuread
$subId = (Get-AzureRmContext).Subscription

run