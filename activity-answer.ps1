# Define reusable variables
$resourceGroup = "MyResourceGroup"
$location = "eastus"
$sqlServer = "MySqlServer"
$adminUser = "adminuser"
$adminPassword = "MyStrongP@ssword123"
$database = "MyDatabase"

# Create the resource group (was missing in the original script)
az group create --name $resourceGroup --location $location

# Create the SQL server
az sql server create `
  --name $sqlServer `
  --resource-group $resourceGroup `
  --location $location `
  --admin-user $adminUser `
  --admin-password $adminPassword

# Create the SQL database
az sql db create `
  --name $database `
  --server $sqlServer `
  --resource-group $resourceGroup `
  --service-objective Basic