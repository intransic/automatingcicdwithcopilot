az sql server create --name MySqlServer `
--resource-group `
--admin-user adminuser `
--admin-password MyStrongP@ssword123
az sql db create `
--name MyDatabase `
--server MySqlServer `
--edition Basic

# After Copilot has made several improvements

# Define variables for easy updates (change these values as needed)
$resourceGroup = "MyResourceGroup"  # Name of the existing Azure resource group
$sqlServerName = "MySqlServer"      # Name of the SQL server to create
$adminUser = "adminuser"            # Admin username for the SQL server
$adminPassword = "MyStrongP@ssword123"  # Admin password (consider using a secure method like environment variables)
$databaseName = "MyDatabase"         # Name of the database to create
$edition = "Basic"                   # Database edition (e.g., Basic, Standard, Premium)

# Create the SQL server
az sql server create `
    --name $sqlServerName `
    --resource-group $resourceGroup `
    --admin-user $adminUser `
    --admin-password $adminPassword

# Check for errors after server creation
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create SQL server '$sqlServerName'. Check if the resource group exists and credentials are correct."
    exit 1
}

# Create the database on the server
az sql db create `
    --name $databaseName `
    --server $sqlServerName `
    --resource-group $resourceGroup `
    --edition $edition

# Check for errors after database creation
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create database '$databaseName' on server '$sqlServerName'."
    exit 1
}

Write-Host "SQL server and database created successfully!"