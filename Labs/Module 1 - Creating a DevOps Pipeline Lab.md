---
title: Secure DevOps and Web Application Security
---

# Secure DevOps and Web Application Security

Module 1: Creating a DevOps Pipeline

Student Lab Manual

Instructor Edition

**Conditions and Terms of Use**

**Microsoft Confidential**

This training package is proprietary and confidential and is intended
only for uses described in the training materials. Content and software
is provided to you under a Non-Disclosure Agreement and cannot be
distributed. Copying or disclosing all or any portion of the content
and/or software included in such packages is strictly prohibited.

The contents of this package are for informational and training purposes
only and are provided \"as is\" without warranty of any kind, whether
express or implied, including but not limited to the implied warranties
of merchantability, fitness for a particular purpose, and
non-infringement.

Training package content, including URLs and other Internet Web site
references, is subject to change without notice. Because Microsoft must
respond to changing market conditions, the content should not be
interpreted to be a commitment on the part of Microsoft, and Microsoft
cannot guarantee the accuracy of any information presented after the
date of publication. Unless otherwise noted, the companies,
organizations, products, domain names, e-mail addresses, logos, people,
places, and events depicted herein are fictitious, and no association
with any real company, organization, product, domain name, e-mail
address, logo, person, place, or event is intended or should be
inferred.

**Copyright and Trademarks**

© 2019 Microsoft Corporation. All rights reserved.

Microsoft may have patents, patent applications, trademarks, copyrights,
or other intellectual property rights covering subject matter in this
document. Except as expressly provided in written license agreement from
Microsoft, the furnishing of this document does not give you any license
to these patents, trademarks, copyrights, or other intellectual
property.

Complying with all applicable copyright laws is the responsibility of
the user. Without limiting the rights under copyright, no part of this
document may be reproduced, stored in or introduced into a retrieval
system, or transmitted in any form or by any means (electronic,
mechanical, photocopying, recording, or otherwise), or for any purpose,
without the express written permission of Microsoft Corporation.

For more information, see Use of Microsoft Copyrighted Content at

<http://www.microsoft.com/en-us/legal/intellectualproperty/Permissions/default.aspx>

DirectX, Hyper-V, Internet Explorer, Microsoft, Outlook, OneDrive, SQL
Server, Windows, Microsoft Azure, Windows PowerShell, Windows Server,
Windows Vista, and Zune are either registered trademarks or trademarks
of Microsoft Corporation in the United States and/or other countries.
Other Microsoft products mentioned herein may be either registered
trademarks or trademarks of Microsoft Corporation in the United States
and/or other countries. All other trademarks are property of their
respective owners.

[[_TOC_]]

## Lab 1: Configure your Azure DevOps Pipelines

**Introduction**

This lab uses a Docker-based ASP.NET Core web application -
MyHealthClinic (MHC). The application will be deployed to a Kubernetes
cluster on Azure Kubernetes Service (AKS) using Azure DevOps. A
"mhc-aks.yaml" file with definitions to deploy on Kubernetes services
such: Load Balancer in the front end and Redis Cache in the back end.

The MHC application will be accessible in the mhc-front end pod along
with the Load Balancer. We use this base environment to learn how to
secure an application and infrastructure by adopting a range of tools.

**Objectives**

After completing this lab, you will be able to:

  - Configure an Azure DevOps Pipeline

  - Trigger a build and a deployment of an application

  - Secure your application and infrastructure through tooling and
    automation

**Prerequisites**

Completion of the Secure DevOps prerequisites lab.

**Estimated Time to Complete This Lab**

60 minutes

### Exercise 1.1: Configure Build Pipeline

**Objectives**

After completing this exercise, you will be able to:

  - Configure an Azure DevOps pipeline

**Scenario**

In this exercise, you will configure a Build Pipeline that will
eventually publish artifacts for the Release Pipeline to consume.

#### Task 1: Import Repository and Build Pipeline 

1.  Start by creating an empty build pipeline. Do not worry, this pipeline
    will not be used. Instead we will be importing a pipeline from a
    JSON file.

    ![Edit Release Pipeline](./Images/Module1-NewImportBuildPipeline_Empty.png)
    ![Edit Release Pipeline](./Images/Module1-NewImportBuildPipeline_Empty_02.png)
    ![Edit Release Pipeline](./Images/Module1-NewImportBuildPipeline_Empty_03.png)
    ![Edit Release Pipeline](./Images/Module1-NewImportBuildPipeline_Empty_04.png)

    > Save this Pipeline as is

2.  Navigate back to the `Pipelines\\Builds` area in Azure DevOps by selecting `Pipeline.`

3.  Under `Pipelines\\Builds`, select `New\\Import a pipeline`

    ![Edit Release Pipeline](./Images/Module1-NewImportBuildPipeline.png)

4.  Select the `MyHealth.AKS.build.json` file in    `"C:\Users\Student\MyHealth.AKS.build.json"` from the local drive.

5.  Once imported, Azure DevOps will present you with the definition
    editing screen. `Make sure you remove the trailing \"-Import\" from your build definition name. Build definition should be named MyHealth.AKS.build.`

    ![](./Images/Module1-NewImportBuildPipelineImported.png)

6.  Select the `Pipeline\\Build Pipeline` area of the definition and
    select `Hosted Ubuntu 1604` for the Agent Pool.

    ![](./Images/Module1-SelectHostToBuild.png)

7. Select the `MyHealthClinicSecDevOps-Public` as Repository in the `Get sources`

    ![](./Images/Module1-NewImportBuildPipelineImported02.png)
8.  Select `Run services` task under the `Tasks` tab then select your
    Azure subscription from the `Azure subscription` dropdown.
    Click `Authorize` to create a connexion with Azure.

    ![](./Images/Module1-SelectSubscriptionRunService.png)

    a.  You will be prompted to authorize this connection with Azure
        credentials. Disable pop-up blocker in your browser if you see a
        blank screen after clicking the OK button, and please retry
        the step.

    b.  This creates an `Azure Resource Manager Service Endpoint`,
        which defines and secures a connection to a Microsoft Azure
        subscription, using Service Principal Authentication (SPA). This
        endpoint will be used to connect `Azure DevOps` and `Azure`.

    > Now you are able to select you Azure Container Registry as it follow:

    ![](./Images/Module1-SelectSubscriptionRunService_Container.png)

9.  Repeat the selection of the same values from the dropdown `Azure subscription` and `Azure Container Registry` for the `Build services`, `Push services` and `Lock services` as shown below.

    ![](./Images/Module1-SelectSubscriptionOtherServices.png)

  > The pipeline tasks are used for automating various items. 
  > The table below provides an overview of each task.
 
  
      |Task                                | Usage|
      |------------------------------------| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
      |Replace tokens in appsettings.json|   Replace ACR in mhc-aks.yaml and database connection string in appsettings.json. This file contains details of the database connection string used to connect to Azure database which was created in the beginning of this lab.|
      |Replace tokens in mhc-aks.yaml    |   This `mhc-aks.yaml` manifest file contains configuration details of `deployments`, `services` and `pods` which will be deployed in Azure Kubernetes Service.|
      |Run services                      |   Prepares suitable environment by pulling required image such as aspnetcore-build:1.0-2.0 and restoring packages mentioned in .csproj. It Pulls microsoft/aspnetcore-build image to build [ASP.NET](http://asp.net/)  Core apps inside the container.|
      |Build services                    |   Builds the docker images specified in a docker-compose.yml file and tags images with \$(Build.BuildId) and latest.|
      |Push services                     |   Pushes the docker image [myhealth.web](http://myhealth.web/)  to Azure Container Registry. Push Docker images with multiple tags to an authenticated Docker Registry or Azure Container Registry and save the resulting repository image digest to a file.|
      |Lock Services                     |   Docker provides a way to lock container images. Once it is locked, nobody can delete it unknowingly, even if they try it shows an error.|

10. Explore the Variable on the `Variables` tab and Check how to configuring the environment with Shared Variables.

    ![](./Images/Module1-ReplaceVariablesServer.png)

  > Variables in this pipeline are not Hard-coded, those Variables. 
  > come from the menu Library, save your Pipeline before to open the Library.

   ![](./Images/Module1-ReplaceVariablesServer_Save.png)

### Exercise 1.2: Configure Release Pipeline


**Objectives**

After completing this exercise, you will be able to:

  - Configure an Azure DevOps pipeline

**Prerequisites**

  - Completion of the Exercise 1.1: Configure Build Pipeline

**Scenario**

In this exercise, you will configure Release Pipeline that gets
triggered soon after the build completes successfully.

##### Task 1 : Import Release Pipeline 

1.  Start by creating an empty release pipeline. Make sure you save the pipeline once you have created it. Do not worry, this pipeline
    will not be used. Instead we will be importing a pipeline from a
    JSON file.

    ![Edit Release Pipeline](./Images/Module1-NewImportBuildPipeline_Empty_Release.png)
    ![Edit Release Pipeline](./Images/Module1-NewImportReleasePipeline_Empty01.png)
    ![Edit Release Pipeline](./Images/Module1-NewImportReleasePipeline_Empty02.png)

2.  Navigate back to the `Release` section under `Pipelines` in the left
    navigation bar. Select New and Import Release Pipeline. Select the
    MyHealth.AKS.Release.json found in `"C:\Users\Student\MyHealth.AKS.Release.json"`
    from the local Cloned Drive 
    
    ![](./Images/Module1-NewImportReleasePipeline.png)

    > **Make sure you remove the trailing `-Copy` from your release definition name. Release definition name should be MyHealth.AKS.Release.**

    ![](./Images/Module1-NewImportReleasePipeline_Copy.png)

3.  Delete the previous created artifacts MyHealth.AKS.build and then click `+ Add` to add an artifact. Select MyHealth.AKS.build as `Source`, `Default version` should be `Latest` and Source.

    ![](./Images/Module1-NewImportReleasePipelineSelectHost.png)

    > Activate the `Continuous Deployment trigger` button as follows

    ![](./Images/Module1-NewImportReleasePipelineSelectHost02.png)

4.  Click on the `Tasks-->Dev` tab and select `DB deployment`.

    > Make sure that the agents selected for each task is a `Hosted Agents (windows 2019)`.

    ![](./Images/Module1-NewImportReleasePipelineConfigureTask.png)
 
5.  In the `Dev` stage, under the `DB deployment` phase, click on
    the `Execute Azure SQL: DacpacTask` task. Under `Azure Service Connection Type`, select from the drop down `Azure Resource Manager`. Under `Azure Subscription`, select your Azure
    subscription.

    ![](./Images/Module1-NewImportReleasePipelineConfigureDB.png)

6.  Under the AKS deployment phase, for the Create Deployments &
    Services in AKS task, update the following fields based on the
    resources you created in the preparation lab:

    > Make sure that the agents selected for each task is a `Azure Pipelines (ubuntu-16.04)`.

    ![](./Images/Module1-NewImportReleasePipelineConfigureAKS01.png)

    a.  Azure Subscription,

    b.  Resource group,

    c.  Kubernetes cluster.

    d.  Expand the Secrets section and update the parameters for Azure
        subscription from the dropdown.

    ![](./Images/Module1-NewImportReleasePipelineConfigureAKS02.png)
    ![](./Images/Module1-NewImportReleasePipelineConfigureAKS03.png)

     Click on the `Update image in AKS` task and repeat the same steps as above.

    ![](./Images/Module1-NewImportBuildPipelineImportedConfigAKS.png)

    > Dont forget Expand the `Secrets` area and use the following values for your
    `Secrets` section `except for the Azure Container Registry`.
    Here you will use the name you defined in the prerequisites
    document.

    ![](./Images/Module1-NewImportBuildPipelineImportedSelectSubscription.png)

    The tasks configured in `Step 5` are used to automate the
    following process:

    a.  `Create Deployments & Services in AKS` will create the
        deployments and services in AKS as per the configuration
        specified in `mhc-aks.yaml` file. The Pods will pull up the
        latest docker image when they are created.

    b.  `Update image in AKS` will pull up the appropriate image
        corresponding to the BuildID from the repository specified, and
        deploys the docker image to the `mhc-front pod` running in
        AKS.

    c.  A secret called `mysecretkey` is created in the AKS cluster
        through a kubectl command run by the pipeline in the background.
        This secret will be used for authorization while pulling
        myhealth.web image from the Azure Container Registry.

7. Explore the Variable on the `Variables` tab and Check how to configuring the environment with Shared Variables (if not linked link the `DevSecOpsVariables` to it).

    ![](./Images/Module1-ReplaceVariablesServer.png)

    > Variables in this pipeline are not Hard-coded, those Variables. 
    > come from the menu Library, save your Pipeline before to open the Library.

    > Note: The Database Name is set to mhcdb and the Server Admin Login is sqladmin and Password is P2ssw0rd1234. <-How’s that for security!

    ![](./Images/Module1-NewImportBuildPipelineImportedConfigureVariableServer.png)
    
    > Save your Release Pipeline

### Exercise 1.3: Trigger a Build and Deploy the application

**Objectives**

After completing this exercise, you will be able to:

  - Configure an Azure DevOps pipeline

**Prerequisites**

  - Completion of the Exercise 1.1 and 1.2

**Scenario**

In this exercise, let us trigger a build manually and upon completion,
an automatic deployment of the application will be triggered. Our
application is designed to be deployed in a Kubernetes pod with the load
balancer in the front-end and Redis cache in the back-end.

1.  Select `Pipelines` in the left navigation bar and under
    the `Builds` section click on the `Queue` button.
    Click `Queue` again when the window titled \"Queue build for
    MyHealth.AKS.build\" pops up.

    ![](./Images/Module1-NewImportBuildPipelineImportedQueueRelease.png)

2.  Once the build process starts, click on the link `Updated appsettings.json` to see the build in progress.

    ![](./Images/Module1-NewImportBuildPipelineImportedResultsRelease.png)

3.  The build will generate and push the docker image to Azure Container Registry in Azure. 
    After the build is completed, you will see the build summary. To view the generated images 
    in the https://portal.azure.com, select the `Azure Container Registry` inside the 
    DevSecOps-XXXXX-RG Resource Group and navigate to the `Repositories`.

    ![](./Images/Module1-AzureResultDeployContainer.png)

4.  Switch back to the Azure DevOps portal. Select the `Release` tab
    in the `Pipelines` section and single-click on the latest release.
    Select `In progress` link to see the live logs and release
    summary.

    ![](./Images/Module1-NewImportBuildPipelineInProgressRelease.png)

5.  Once the release is complete, go to the same powershell that you used to execute the Script and run the below
    commands to see the pods running in AKS:

    > If you didn't close the powershel windows, skip the next 2 steps
    > and commands for the step c and 8 are in the output powershell
    
    a.  Type `az login` in the command
        prompt and press Enter. Authenticate yourself by entering your
        credentials in the web browser that automatically opens up.

    ![](./Images/Module1-AzureResultAKSSetup.png)

    b.  Type `az account show` to see the active subscription you are
        connected to. If it is not the right one, type `az account set --subscription [name or id\]`, replacing name or id with the
        one for the right subscription, which you can find in the list
        generated when running the command `az login` above.

    c.  Type `az aks get-credentials --resource-group yourResourceGroup --name yourAKSname` in the command prompt to get the access credentials
        for the Kubernetes cluster. Replace the
        variables `yourResourceGroup` and `yourAKSname` with the
        actual values.

    ![](./Images/Module1-AzureResultAKSSetupGetCredentials.png)

    d.  Type `kubectl get pods` to see the pods that are running (if
        the command is not recognized make sure that you set the
        installation folder for kubectl.exe into your environment PATH
        variable):

    ![](./Images/Module1-AzureResultAKSSetupGetPods.png)

    > The deployed web application is running in the displayed pods. Make sure both `STATUS` is \"Running\".

6.  To see what external IP address the application is using, run the
    below command. If you see that `External-IP` is pending, wait for
    sometime until an IP is assigned.

    `kubectl get service mhc-front --watch`

    ![](./Images/Module1-AzureResultAKSShowPortsAKS.png)

7.  Copy the External-IP and paste it in the browser and press the Enter
    button to launch the application.

    ![](./Images/Module1-AzureResultAKSShowPortsAKS_Site.png)

8.  Access Azure Kubernetes Services (AKS) through the browser Type the below command in the
    command prompt to access the AKS through the browser.

    `az aks browse --resource-group YourResourceGroup --name yourAKSname`

    ![](./Images/Module1-AzureResultAKSSetupShowBrowser.png)

    > Once the `AKS Dashboard` is launched, the following details will be displayed.

    ![](./Images/Module1-AzureResultAKSDashboard.png)
