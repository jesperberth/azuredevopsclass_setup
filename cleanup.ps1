# Usage
#
# Remove Users, Resourcegroups for Azure DevOpsClass
#
# using native azure ad users
#
# Author: Jesper Berth, jesper.berth@arrow.com - january 2022

# Begin User Cleanup

$azureaduser = get-azureaduser | Where-Object UserPrincipalName -Match "^devopsuser.*"

write-host -ForegroundColor Yellow "These are the users to delete"

foreach ($user in $azureaduser) {
    Write-Host $user.UserPrincipalName
}

do {
    $response = Read-Host -Prompt "Delete users y/n"
    if ($response -eq 'y') {
        foreach ($user in $azureaduser) {
            remove-azureaduser -ObjectId $user.UserPrincipalName
        }
    $response = "n"
    }
} 	until ($response -eq 'n')

# End User Cleanup

# Begin RG Webserver

$webserver = Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^webserver.*"
write-host -ForegroundColor Yellow "webserver* resourcegroups to delete"

foreach ($rg in $webserver) {
    Write-Host $rg.ResourceGroupName
}

do {
    $response = Read-Host -Prompt "Delete Resourcegroups y/n"
    if ($response -eq 'y') {
        foreach ($rg in $webserver) {
            Remove-AzResourceGroup $rg.ResourceGroupName -Force -AsJob
        }
    $response = "n"
    }
} 	until ($response -eq 'n')

# End RG Webserver

# Begin Azure Container Registry

do {
    $response = Read-Host -Prompt "Delete container repositorys y/n"

    write-host -ForegroundColor Yellow "webserver* resourcegroups to delete'n"

    az acr repository list --name teamredhatarrow --output tsv

    if ($response -eq 'y') {
        foreach ($repo in az acr repository list --name teamredhatarrow --output tsv ) {
        Write-Output "Deleting container repository $repo"
        az acr repository delete --name teamredhatarrow --image $repo
        }
    $response = "n"
    }
} until ($response -eq 'n')

# End Azure Container Registry
write-host "Remaining resource groups"
Get-AzResourceGroup | Select-Object ResourceGroupName