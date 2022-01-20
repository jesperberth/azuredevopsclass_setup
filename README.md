# Azure DevOps Class Setup

## Create users in azure

Open a azure cloud shell

Run in Powershell

Setup_users.ps1

Select a region

number of users to deploy

Default password for all new users

```bash
cd clouddrive

git clone https://github.com/jesperberth/automationclass_setup.git

cd automationclass_setup

connect-azuread

setup_users.ps1

```

## Cleanup Azure

```bash
cd clouddrive

cd automationclass_setup

connect-azuread

cleanup.ps1

```
