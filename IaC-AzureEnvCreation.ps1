# Create variables to use in the lab
$version=(az aks get-versions -l eastus --query 'orchestrators[-1].orchestratorVersion' -o tsv)
$unicstr = -join ((97..122) | Get-Random -Count 5 | % {[char]$_})
$aksname = "devsecops"+ $unicstr + "aks" 
$rgname = "DevSecOps-" + $unicstr + "-RG"
$acrname = "devsecops" + $unicstr + "acr"
$sqlsvname =  "devsecops" + $unicstr + "db"
$appServicePlan = "owasp" + $unicstr + "t10"
$app = "owaspapp" + $unicstr + "t10"

# Register the network provider
az provider register --namespace Microsoft.Network

# Create a ressource groupe
az group create --name $rgname --location eastus
Write-Host 'Ressource groupe : ' + $rgname + ' created '

az ad sp create-for-rbac --name $aksname

# Create AKS Service
az aks create --resource-group $rgname --name $aksname --enable-addons monitoring --kubernetes-version 1.12.7 --generate-ssh-keys --location eastus --disable-rbac
Write-Host 'Azure Kubernetes Service : ' + $aksname + ' created '

# Create ACR service
az acr create --resource-group $rgname --name $acrname --sku Standard --location eastus
Write-Host 'Azure Container Registry : ' + $acrname + ' created '

# Get the id of the service principal configured for AKS
$CLIENT_ID=(az aks show --resource-group $rgname --name $aksname --query "servicePrincipalProfile.clientId" --output tsv)

# Get the ACR registry resource id
$ACR_ID=(az acr show --name $acrname --resource-group $rgname --query "id" --output tsv)

# Create role assignment
az role assignment create --assignee $CLIENT_ID --role acrpull --scope $ACR_ID

# Create database server
az sql server create -l eastus -g $rgname -n $sqlsvname -u sqladmin -p P2ssw0rd1234

az sql db create -g $rgname -s $sqlsvname -n mhcdb --service-objective S0

# Create service plan for OWASP top 10
az appservice plan create -g $rgname -n $appServicePlan --is-linux --number-of-workers 1 --sku B1

# Create service WebApp for OWASP top 10
az webapp create --resource-group $rgname --plan $appServicePlan --name $app --deployment-container-image-name bkimminich/juice-shop

Write-Host "======================================================================================================`n
Please take note of the following ressource names, they will be used in the next steps `n
======================================================================================================
            Azure Container Registry name : $($acrname).azurecr.io `n
            SQL Server name : $($sqlsvname).database.windows.net `n
            Azure Kubernetes Services name : $($aksname) `n"