# Create variables to use in the lab
$version=(az aks get-versions -l eastus --query 'orchestrators[-1].orchestratorVersion' -o tsv)
$unicstr = -join ((97..122) | Get-Random -Count 5 | % {[char]$_})
$aksname = "devsecops"+ $unicstr + "aks" 
$rgname = "DevSecOps-" + $unicstr + "-RG"
$acrname = "devsecops" + $unicstr + "acr"
$sqlsvname =  "devsecops" + $unicstr + "db"
$appServicePlan = "owasp" + $unicstr + "t10"
$app = "owaspapp" + $unicstr + "t10"
$repomyclinic = 'MyHealthClinicSecDevOps-Public'
$keyvaultname = "devsecops" + $unicstr + "akv"

Write-Host 'If you already executed this script, go to https://portal.azure.com and delete old resources first'
Write-Host 'Delete as well DevSecOpsVariables on the Library in https://dev.azure.com'
Write-Host '---------------------------------------------------------------------------------------------------'
Write-Host '\n'
Write-Host 'Login in with your new accounr e.g. DevSecOpsYourName@outlook.com'
Write-Host 'Login in with your new accounr e.g. DevSecOpsYourName@outlook.com'
$output = az Login
if (!$output) {
    Write-Error "Error validating the credentials"
    return
}

#Add DevOps Powershell Extention
az extension add --name azure-devops

#Configure local variables to call DevOps Services
$devopspat = Read-Host -Prompt 'Enter Personal Token Access (PAT) created in the first part of requisites.'
$devopsservice = Read-Host -Prompt 'Type the name of URL DevOps with your organization e.g. : https://dev.azure.com/DevSecOpsBob001.'
$devopsproject = Read-Host -Prompt 'Type the name of you project created in your DevOps.'
$env:AZURE_DEVOPS_EXT_PAT = $devopspat
az devops configure --defaults project=$devopsproject organization=$devopsservice
	
Write-Host 'Downloading required lab files'
Invoke-WebRequest 'https://dev.azure.com/secureDevOpsDelivery/82dd0a19-ef30-4974-837a-b876e341813a/_apis/git/repositories/42215aa8-8ad3-4dbc-bd08-29ffc8c37e90/items?path=%2FBuildScripts%2FMyHealth.AKS.build.json&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=octetStream&api-version=5.0&download=true' -UseBasicParsing -OutFile 'C:\Users\Student\MyHealth.AKS.build.json'
Invoke-WebRequest 'https://dev.azure.com/secureDevOpsDelivery/82dd0a19-ef30-4974-837a-b876e341813a/_apis/git/repositories/42215aa8-8ad3-4dbc-bd08-29ffc8c37e90/items?path=%2FReleaseScripts%2FMyHealth.AKS.Release.json&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=octetStream&api-version=5.0&download=true' -UseBasicParsing -OutFile 'C:\Users\Student\MyHealth.AKS.Release.json'

#Create a Repo for the Labs
Write-Host 'Importing labs to your Azure DevOps'
az repos create --name $repomyclinic --project $devopsproject

#Import the repo from Demo Website
az repos import create --git-source-url 'https://SecureDevOpsDelivery@dev.azure.com/SecureDevOpsDelivery/MyHealthClinicSecDevOps-Public/_git/MyHealthClinicSecDevOps-Public' --detect true --project $devopsproject --repository $repomyclinic

Write-Host 'Adding security extensions to your Azure DevOps'
az devops extension install --extension-id 'AzSDK-task' --publisher-id 'azsdktm' --detect true
az devops extension install --extension-id 'SonarCloud' --publisher-id 'SonarSource' --detect true
az devops extension install --extension-id 'replacetokens' --publisher-id 'qetza' --detect true
az devops extension install --extension-id 'ws-bolt' --publisher-id 'whitesource' --detect true

#Creating variable group'
az pipelines variable-group create --name 'DevSecOpsVariables' --variables ACR=$acrname'.azurecr.io' DatabaseName='mhcdb' ExtendedCommand='-GenerateFixScript' SQLpassword='P2ssw0rd1234' SQLserver=$appServicePlan'.database.windows.net' SQLuser='sqladmin' --project $devopsproject --authorize true

# Register the network provider
az provider register --namespace Microsoft.Network

# Create a Key Vault to store secrets
az keyvault create --location eastus --name $keyvaultname --resource-group $rgname --sku standard
az keyvault secret set --name SQLpassword --vault-name $keyvaultname --value P2ssw0rd1234

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
			Azure Kubernetes Services name : $($aksname) `n
			Resource Groupe name : $($rgname) `n"
