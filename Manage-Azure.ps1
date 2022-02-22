<#
    This Coding technique is using automation mindset 
    Desired State Automation = Insert and Update = UpSert  
#>




function   set-azResourceGroup {
    <#
            .SYNOPSIS
            Create Azure ResourceGroup for first time or
            Update existing Azure ResourceGroup for delta changes like tagging and versioning 

            .PARAMETER resourceGroupName
            Resource groups should follow as much as possible the standard as follow:

            product_name/functionality-environment-location-rg
            environment - should be clearly stating what kind of environment it contains i.e. prod / stage / test / dev / qa
            location - should be an abbreviation of Azure Regions i.e. West Europe -> euw, North Europe -> use eun

            i.e. onecustomer-dev-euw-rg
            i.e. onecustomer-test-euw-rg
            
            i.e. onecustomer-qa-eun-rg
            i.e. onecustomer-prod-eun-rg

            .PARAMETER azureRegion
            Azure Data center close to home (Copenhagen)
            choice betweeen 
            - West Europe 
            - North Europe
            
            .PARAMETER version
            Semantic Versioning must align with git versioning for traceability 
            
            .EXAMPLE
            Set-azResourceGroup -resourceGroupName "zerotrust-dev-euw-rg" -azureRegion "West Europe" -version "1.0.0" 
            .EXAMPLE
            Set-azResourceGroup -resourceGroupName "zerotrust-dev-euw-rg" -azureRegion "West Europe" -version "2.0.0" 
            .EXAMPLE
            Set-azResourceGroup -resourceGroupName "zerotrust-dev-euw-rg" -azureRegion "West Europe" -version "2.1.0" 
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'Azure ResourceGroup name')]
        [string] $resourceGroupName,
        
        [Parameter(Mandatory = $true, HelpMessage = 'Azure Region')]
        [ValidateSet("West Europe", "North Europe")]
        [string] $azureRegion,
        
        [Parameter(Mandatory = $true, HelpMessage = 'Align git version and Azure Resources for traceability and history')]
        [string] $version
    )
  
    az group create              `
        --name $resourceGroupName    `
        --location $azureRegion      `
        --tags "deployment=automation" "gitVersion=$version"    
}
  
  

function set-azStorageAccount {
    [CmdletBinding()]
    param(
        [string] $resourceGroupName,
        [string] $azureRegion,
        [string] $storageAccountName 
    )

    az storage account create               `
        --name $storageAccountName            `
        --resource-group $resourceGroupName   `
        --location $azureRegion               `
        --sku Standard_LRS                    `
        --enable-hierarchical-namespace $true

}
  
  
function get-azStorageAccountConnectionString {
    [CmdletBinding()]
    param (
        [string] $resourceGroupName,
        [string] $azureRegion,
        [string] $storageAccountName 
    )
    # Get the ConnectionString from the Storage Account and save it in memory variable as string to be returned    
    $connectionString = $(az storage account show-connection-string --name $storageAccountName --resource-group $resourceGroupName --query connectionString -o tsv)
    return $connectionString
}
  
function get-azSecret {
    [CmdletBinding()]
    param(
        [string] $secretName,
        [string] $vaultName = "zerotrust"
    )
    # Get a secret from KeyVault and return the Value 
    $secret = $(az keyvault secret show --vault-name $vaultName --name $secretName --query "value" --output tsv)
    return $secret
}
  

function set-azSecret {
    [CmdletBinding()]
    param(
        [string] $secretName,
        [string] $secretValue,
        [string] $vaultName = "zerotrust"
    )
    az keyvault secret set --vault-name $vaultName --name $secretName --value $secretValue
}