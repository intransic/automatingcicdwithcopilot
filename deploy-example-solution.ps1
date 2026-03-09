# Set default values for location and group
az configure --defaults group=MyResourceGroup location=eastus
# Create a resource group in the default location
az group create --name MyResourceGroup --location eastus
# Create a virtual machine with free-tier settings and SSH key setup
az vm create `
--name MyVM `
--image UbuntuLTS `
--size Standard_B1s `
--admin-username azureuser `
--generate-ssh-keys


########### REFACTORED VERSION WITH ERROR HANDLING ###########

<#
.SYNOPSIS
    Deploys a basic Azure resource group and Linux VM using Azure CLI.

.DESCRIPTION
    This script creates a resource group and a free-tier Linux VM with SSH keys.
    It can be reused by passing different parameters for multiple deployments.

.PARAMETER ResourceGroupName
    The name of the Azure resource group to create.

.PARAMETER Location
    The Azure region for the resources (e.g., eastus, westus2).

.PARAMETER VMName
    The name of the virtual machine to create.

.PARAMETER VMSize
    The size of the VM (default: Standard_B1s for free tier).

.PARAMETER AdminUsername
    The admin username for the VM (default: azureuser).

.PARAMETER Image
    The VM image (default: UbuntuLTS).
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$Location,

    [Parameter(Mandatory = $true)]
    [string]$VMName,

    [string]$VMSize = "Standard_B1s",
    [string]$AdminUsername = "azureuser",
    [string]$Image = "UbuntuLTS"
)

# Function to set Azure CLI defaults
function Set-AzCliDefaults {
    param ([string]$Group, [string]$Location)
    Write-Host "Setting Azure CLI defaults: Group=$Group, Location=$Location"
    az configure --defaults group=$Group location=$Location
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to set Azure CLI defaults."
    }
}

# Function to create a resource group
function New-ResourceGroup {
    param ([string]$Name, [string]$Location)
    Write-Host "Creating resource group: $Name in $Location"
    az group create --name $Name --location $Location
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create resource group '$Name'."
    }
}

# Function to create a virtual machine
function New-VirtualMachine {
    param ([string]$Name, [string]$ResourceGroup, [string]$Image, [string]$Size, [string]$AdminUser)
    Write-Host "Creating VM: $Name in resource group $ResourceGroup"
    az vm create `
        --resource-group $ResourceGroup `
        --name $Name `
        --image $Image `
        --size $Size `
        --admin-username $AdminUser `
        --generate-ssh-keys
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create VM '$Name'."
    }
}

# Main script logic
try {
    # Set defaults
    Set-AzCliDefaults -Group $ResourceGroupName -Location $Location

    # Create resource group
    New-ResourceGroup -Name $ResourceGroupName -Location $Location

    # Create VM
    New-VirtualMachine -Name $VMName -ResourceGroup $ResourceGroupName -Image $Image -Size $VMSize -AdminUser $AdminUsername

    Write-Host "Deployment completed successfully!"
} catch {
    Write-Error "Deployment failed: $($_.Exception.Message)"
    exit 1
}