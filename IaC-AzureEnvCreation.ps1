# Create variables to use in the lab
$WarningPreference = "SilentlyContinue"
$location = 'eastus'

$unicstr = -join ((97..122) | Get-Random -Count 5 | % {[char]$_})
$aksexists = $false
$acrexists = $false
$dbexists = $false
$svcpexists = $false
$appexists = $false
$kvexists = $false
$snrexists = $false

Write-Host ''
Write-Host '---------------------------------------------------------------------------------------------------'
Write-Host 'If you already executed this script, go to https://portal.azure.com and delete old resources first'
Write-Host 'Delete as well DevSecOpsVariables on the Library in https://dev.azure.com'
Write-Host '---------------------------------------------------------------------------------------------------'
Write-Host ''
Write-Host 'A new window will open, please log in and go back here'
Write-Host ''
Write-Host 'Login in with your new accounr e.g. DevSecOpsYourName@outlook.com'
Write-Host 'in case of error in az cli, please re-install and re-open using the following command'
Write-Host ''
Write-Host "Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi'"


$output = az Login
if (!$output) {
    Write-Error "Error validating the credentials"
    return
}

$a = az resource list --query --% "[?contains(name,'devsecops')].[name]" -o table
# To validate if the resource already exists
try 
{
    foreach ($item in $a) {
        $unicstr = $a[2].substring(9,5)
        switch ($item) {
            ("devsecops"+ $unicstr + "aks"){ $aksexists = $true}
            ("devsecops" + $unicstr + "acr"){ $acrexists = $true}
            ("devsecops" + $unicstr + "db"){ $dbexists = $true}
            ("devsecopsowasp" + $unicstr + "t10"){ $svcpexists = $true}
            ("devsecopsowaspapp" + $unicstr + "t10"){ $appexists = $true}
            ("devsecops" + $unicstr + "akv"){ $kvexists = $true}
            ("devsecops" + $unicstr + "snr"){ $snrexists = $true}
        }
    }
    Write-Host 'Resources found in Azure: ' + $a
}
catch 
    {
        #Ignore this error
    }

$rgname = "devsecops-" + $unicstr + "-rg"
$aksname = "devsecops"+ $unicstr + "aks" 
$acrname = "devsecops" + $unicstr + "acr"
$sqlsvname =  "devsecops" + $unicstr + "db"
$appServicePlan = "devsecopsowasp" + $unicstr + "t10"
$app = "devsecopsowaspapp" + $unicstr + "t10"
$keyvaultname = "devsecops" + $unicstr + "akv"
$sonarqaciname = "devsecops" + $unicstr + "snr"

$repomyclinic = 'MyHealthClinicSecDevOps-Public'

#Add DevOps Powershell Extention
az extension add --name azure-devops

#Configure local variables to call DevOps Services
$devopspat = Read-Host -Prompt 'Enter Personal Token Access (PAT) created in the first part of requisites.'
$devopsservice = Read-Host -Prompt 'Type the name of URL DevOps with your organization e.g. : https://dev.azure.com/YOUR_ORGNIZATION_NAME'
$devopsproject = Read-Host -Prompt 'Type the name of you project created in your DevOps.'
$env:AZURE_DEVOPS_EXT_PAT = $devopspat
az devops configure --defaults project=$devopsproject organization=$devopsservice
	
Write-Host 'Downloading required lab files'
Invoke-WebRequest 'https://dev.azure.com/secureDevOpsDelivery/82dd0a19-ef30-4974-837a-b876e341813a/_apis/git/repositories/42215aa8-8ad3-4dbc-bd08-29ffc8c37e90/items?path=%2FBuildScripts%2FMyHealth.AKS.build.json&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=octetStream&api-version=5.0&download=true' -UseBasicParsing -OutFile '.\MyHealth.AKS.build.json'
Invoke-WebRequest 'https://dev.azure.com/secureDevOpsDelivery/82dd0a19-ef30-4974-837a-b876e341813a/_apis/git/repositories/42215aa8-8ad3-4dbc-bd08-29ffc8c37e90/items?path=%2FReleaseScripts%2FMyHealth.AKS.Release.json&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=octetStream&api-version=5.0&download=true' -UseBasicParsing -OutFile '.\MyHealth.AKS.Release.json'

#Create a Repo for the Labs
Write-Host 'Importing labs to your Azure DevOps'
az repos create --name $repomyclinic --project $devopsproject

#Import the repo from Demo Website
Write-Host 'Running importing Lab to student repo ......' 
az repos import create --git-source-url 'https://SecureDevOpsDelivery@dev.azure.com/SecureDevOpsDelivery/MyHealthClinicSecDevOps-Public/_git/MyHealthClinicSecDevOps-Public' --detect true --project $devopsproject --repository $repomyclinic

Write-Host 'Adding security extensions to your Azure DevOps'
az devops extension install --extension-id 'AzSDK-task' --publisher-id 'azsdktm' --detect true
az devops extension install --extension-id 'sonarqube' --publisher-id 'SonarSource' --detect true
az devops extension install --extension-id 'replacetokens' --publisher-id 'qetza' --detect true
az devops extension install --extension-id 'ws-bolt' --publisher-id 'whitesource' --detect true

#Creating variable group'
az pipelines variable-group create --name 'DevSecOpsVariables' --variables ACR=$acrname'.azurecr.io' DatabaseName='mhcdb' ExtendedCommand='-GenerateFixScript' SQLpassword='P2ssw0rd1234' SQLserver=$sqlsvname'.database.windows.net' SQLuser='sqladmin' --project $devopsproject --authorize true

# Register the network provider
az provider register --namespace Microsoft.Network

# Create a ressource groupe
Write-Host 'Running Resource Group .....' 
if ($(az group exists --name $rgname) -eq $false)
{
    az group create --name $rgname --location $location --verbose
    Write-Host 'Ressource groupe : ' + $rgname + ' created '
}

# Create a Key Vault to store secrets
Write-Host 'Running Key Vault.....' 
if ($kvexists -eq $false)
{
    az keyvault create --location $location --name $keyvaultname --resource-group $rgname --sku standard
    az keyvault secret set --name SQLpassword --vault-name $keyvaultname --value P2ssw0rd1234
    Write-Host 'Keyvault : ' + $keyvaultname + ' created '
}

Write-Host 'Running Azure Kubernetes Services setup .....' 
if ($aksexists -eq $false)
{
    $spn = (az ad sp create-for-rbac --name $aksname) | ConvertFrom-Json

    Write-Host 'Service Principal Name : created '

    # Create AKS Service
    az aks create --resource-group $rgname --name $aksname --enable-addons monitoring --kubernetes-version 1.15.5 --generate-ssh-keys --location $location --disable-rbac --service-principal $spn.appId --client-secret $spn.password
    Write-Host 'Azure Kubernetes Service : ' + $aksname + ' created '
}

# Create ACR service
Write-Host 'Running ACR service .....' 
if ($acrexists -eq $false)
{
    az acr create --resource-group $rgname --name $acrname --sku Standard --location $location
    Write-Host 'Azure Container Registry : ' + $acrname + ' created '

    # Get the id of the service principal configured for AKS
    $CLIENT_ID=(az aks show --resource-group $rgname --name $aksname --query "servicePrincipalProfile.clientId" --output tsv)

    # Get the ACR registry resource id
    $ACR_ID=(az acr show --name $acrname --resource-group $rgname --query "id" --output tsv)

    # Create role assignment
    az role assignment create --assignee $CLIENT_ID --role acrpull --scope $ACR_ID
    Write-Host 'Access from AKS to ACR : granted '
}

# Create database server
Write-Host 'Running database server .....' 
if ($dbexists -eq $false)
{
    az sql server create -l $location -g $rgname -n $sqlsvname -u sqladmin -p P2ssw0rd1234
    Write-Host 'Azure SQL Server : ' + $sqlsvname + ' created '

    az sql db create -g $rgname -s $sqlsvname -n mhcdb --service-objective S0
    Write-Host 'Databae on SQL Server : mhcdb created '
}

# Create service plan for OWASP top 10
Write-Host 'Running service plan .....' 
if ($svcpexists -eq $false)
{
    az appservice plan create -g $rgname -n $appServicePlan --is-linux --number-of-workers 1 --sku B1
    Write-Host 'Azure App Service plan : ' + $appServicePlan + ' created '
}

# Create service WebApp for OWASP top 10
Write-Host 'Running WebApp .....' 
if ($appexists -eq $false)
{
    az webapp create --resource-group $rgname --plan $appServicePlan --name $app --deployment-container-image-name bkimminich/juice-shop
    Write-Host 'Azure Web App : ' + $app + ' created '
}

# Create service SonarQube  in Azure Container Instances
Write-Host 'Running SonarQube .....' 
if ($snrexists -eq $false)
{
    az container create -g $($rgname) --name $sonarqaciname --image sonarqube --ports 9000 --dns-name-label $sonarqaciname'dns' --cpu 2 --memory 3.5
    Write-Host 'Azure Web App SonarQube : ' + $sonarqaciname + ' created '
}

# Create service SonarQube  in Azure Container Instances
Write-Host 'Installing Kubernetes cli .....' 
az aks install-cli
$env:path += ';C:\Users\Student\.azure-kubectl'

Write-Host "====================================================================================================== 
Please take note of the following ressource names, they will be used in the next labs 
====================================================================================================== 
			Azure Container Registry name : $($acrname).azurecr.io 
			SQL Server name : $($sqlsvname).database.windows.net
			Azure Kubernetes Services name : $($aksname) 
			Resource Groupe name : $($rgname) 
			
			You'll be using the following commands in the Lab 1 
			
			SonarQube Instance: 
			http://$($sonarqaciname)dns.eastus.azurecontainer.io:9000 
			`n
			Azure Kubernetes Services instance: `n
			az aks get-credentials --resource-group $($rgname) --name $($aksname) 
			az aks browse --resource-group $($rgname) --name $($aksname)"
