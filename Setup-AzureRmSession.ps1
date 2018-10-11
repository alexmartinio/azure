<#
.SYNOPSIS
    Setup an AzureRM session
.DESCRIPTION
    This file can be sourced to create a new AzureRM session
.NOTES
    Author: Alex Martin
    Date:   2018-10-10
.EXAMPLE
    C:\PS> Setup-AzureRmSession.ps1
#>


Try {
    $Module = "AzureRM"
    Import-Module -Name $Module -ErrorAction Stop
}
Catch {
    Write-Warning "Could not find '$Module' module... attempting install.."
    Try {
        Install-Module -Name $Module -AllowClobber
    }
    Catch {
        throw $_
    }
    Import-Module -Name $Module
}

## Login to AzureRM if needed
Try {
    Get-AzureRmContext | Out-Null
}
Catch {
    Connect-AzureRmAccount
}

$Subscriptions = Get-AzureRmSubscription
Write-Output "Available subscriptions:"

If ($Subscriptions.Count -gt 1) {
    $Subscriptions | ForEach-Object {$i = 0} {$i++; Write-Output "$i. $($_.Name)"}
    Write-Host
    $Choice = Read-Host -Prompt "Please choose a subscription to work with"
    Select-AzureRmSubscription $Subscriptions[$Choice - 1]
    
}

Write-Output "`n`n"
Write-Output "Resource groups for subscription: "
Get-AzureRmResourceGroup | Select-Object ResourceGroupName, Location | Format-Table

