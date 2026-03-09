# az group create --name MyResourceGroup --location
# az vm create --resource-group MyResourceGroup --name MyVM --image UbuntuLTS
# az configure --defaults group=MyResourceGroup location=eastus

# Create a resource group in East US
az group create --name MyResourceGroup --location eastus
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create resource group. Exiting."
    exit 1
}

# Create a virtual machine in the resource group
az vm create --resource-group MyResourceGroup --name MyVM --image Ubuntu2204 --generate-ssh-keys
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create VM. Exiting."
    exit 1
}

# Set default resource group and location for future commands
az configure --defaults group=MyResourceGroup location=eastus