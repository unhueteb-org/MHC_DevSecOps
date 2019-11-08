# Create variables to use in the lab
$version=(az aks get-versions -l eastus --query 'orchestrators[-1].orchestratorVersion' -o tsv)
$unicstr = -join ((97..122) | Get-Random -Count 5 | % {[char]$_})
$aksname = "devsecops"+ $unicstr + "aks" 
$rgname = "akshandsonlab-" + $unicstr + "-rg"
$acrname = "devsecops" + $unicstr + "acr"
$sqlsvname =  "devsecops" + $unicstr + "db"

# Register the network provider
az provider register --namespace Microsoft.Network

# Create a ressource groupe
az group create --name akshandsonlab-$unicstr-rg --location eastus
Write-Host 'Ressource groupe : $($rgname) created '

# Create AKS Service
az aks create --resource-group $rgname --name $aksname --enable-addons monitoring --kubernetes-version $version --generate-ssh-keys --location eastus
Write-Host 'Azure Kubernetes Service : $($aksname) created '

# Create ACR service
az acr create --resource-group $rgname --name $acrname --sku Standard --location eastus
Write-Host 'Azure Container Registry : $($acrname) created '

# Get the id of the service principal configured for AKS
$CLIENT_ID=(az aks show --resource-group $rgname --name $aksname --query "servicePrincipalProfile.clientId" --output tsv)

# Get the ACR registry resource id
$ACR_ID=(az acr show --name $acrname --resource-group $rgname --query "id" --output tsv)

# Create role assignment
az role assignment create --assignee $CLIENT_ID --role acrpull --scope $ACR_ID

# Create database server
az sql server create -l eastus -g $rgname -n $sqlsvname -u sqladmin -p P2ssw0rd1234

az sql db create -g $rgname -s $sqlsvname -n mhcdb --service-objective S0

Write-Host "======================================================================================================`n
Please take note of the following ressource names, they will be used in the next steps `n
======================================================================================================
            SQL Server name : $($sqlsvname).database.windows.net `n
            Azure Container Registry name : $($acrname).azurecr.io `n
            Azure Kubernetes Services name : $($aksname) `n"