---
title: Secure DevOps and Web Application Security
---

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

-   Configure an Azure DevOps Pipeline

-   Trigger a build and a deployment of an application

-   Secure your application and infrastructure through tooling and
    automation

**Prerequisites**

Completion of the Secure DevOps prerequisites lab.

**Estimated Time to Complete This Lab**

60 minutes

###Exercise 1.1: Configure Build Pipeline

**Objectives**

After completing this exercise, you will be able to:

-   Configure an Azure DevOps pipeline

**Scenario**

In this exercise, you will configure a Build Pipeline that will
eventually publish artifacts for the Release Pipeline to consume.

#### Task 1: Import Repository and Build Pipeline {#task-1-import-repository-and-build-pipeline .Procedureheading}

1.  Start by creating an empty pipeline. Do not worry, this pipeline
    will not be used. Instead we will be importing a pipeline from a
    JSON file.

2.  Navigate to the **Pipelines\\Builds** area in Azure DevOps by
    selecting **Pipeline.**

3.  If there is a build definition named MyHealthClinicE2E. Disregard
    this definition as it will not be used in our lab. If it becomes a
    distraction, feel free to delete it.

4.  Under **Pipelines\\Builds**, select **New\\Import a pipeline**

    ![Edit Release Pipeline](/Images/Module1-NewImportBuildPipeline.png)

5.  Select the **MyHealth.AKS.build.json** file in
    \"\\MyHealthClinicSecDevOps-Public\\BuildScripts\\MyHealth.AKS.build.json\"
    from the local Cloned Repo and import the definition.

6.  Once imported, Azure DevOps will present you with the definition
    editing screen. **Make sure you remove the trailing -Import from
    your build definition. Build definition should be named
    MyHealth.AKS.build.**

    ![](media/image2.png){width="5.997025371828522in" height="2.8in"}

7.  Select the **Pipeline\\Build Pipeline** area of the definition and
    select **Hosted Ubuntu 1604** for the Agent Pool.

    ![](media/image3.png){width="6.0in" height="1.2694444444444444in"}

8.  In **Run services** section, under the **Tasks** tab select your
    Azure subscription from the **Azure subscription** dropdown.
    Click **Authorize**.

    ![](media/image4.png){width="5.363888888888889in"
    height="2.104009186351706in"}

    a.  You will be prompted to authorize this connection with Azure
        credentials. Disable pop-up blocker in your browser if you see a
        blank screen after clicking the OK button, and please retry
        step 6.

    b.  This creates an **Azure Resource Manager Service Endpoint**,
        which defines and secures a connection to a Microsoft Azure
        subscription, using Service Principal Authentication (SPA). This
        endpoint will be used to connect **Azure DevOps** and **Azure**.

9.  Repeat the selection of the same values from the dropdown **Azure
    subscription** and **Azure Container Registry** for the **Build
    services**, **Push services** and **Lock services** as shown below.

    ![](media/image5.png){width="6.0in" height="2.779861111111111in"}

10. The pipeline tasks are used for automating various items. The table
    below provides an overview of each task.

  Task                                 Usage
  ------------------------------------ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Replace tokens in appsettings.json   Replace ACR in mhc-aks.yaml and database connection string in appsettings.json. This file contains details of the database connection string used to connect to Azure database which was created in the beginning of this lab.
  Replace tokens in mhc-aks.yaml       This **mhc-aks.yaml** manifest file contains configuration details of **deployments**, **services** and **pods** which will be deployed in Azure Kubernetes Service.
  Run services                         Prepares suitable environment by pulling required image such as aspnetcore-build:1.0-2.0 and restoring packages mentioned in .csproj. It Pulls microsoft/aspnetcore-build image to build [ASP.NET](http://asp.net/)  Core apps inside the container.
  Build services                       Builds the docker images specified in a docker-compose.yml file and tags images with \$(Build.BuildId) and latest.
  Push services                        Pushes the docker image [myhealth.web](http://myhealth.web/)  to Azure Container Registry. Push Docker images with multiple tags to an authenticated Docker Registry or Azure Container Registry and save the resulting repository image digest to a file.
  Lock Services                        Docker provides a way to lock container images. Once it is locked, nobody can delete it unknowingly, even if they try it shows an error.

11. Click on the **Variables** tab and
    update **ACR** and **SQLserver** values for **Pipeline
    Variables** with the details noted earlier while configuring the
    environment. Select the **Save** button and Select **Save** button
    in the Save Build Pipeline dialog.

    ![](media/image6.png){width="6.0in" height="2.736111111111111in"}

Exercise 1.2: Configure Release Pipeline
----------------------------------------

#### Objectives

After completing this exercise, you will be able to:

-   Configure an Azure DevOps pipeline

#### Prerequisites

Completion of the Exercise 1.1: Configure Build Pipeline

#### Scenario

In this exercise, you will configure Release Pipeline that gets
triggered soon after the build completes successfully.

#### Task 1 : Import Release Pipeline {#task-1-import-release-pipeline .Procedureheading}

1.  Navigate to the **Release** section under **Pipelines** in the left
    navigation bar. Select New and Import Release Pipeline. Select the
    MyHealth.AKS.Release.json found in
    \"\\MyHealthClinicSecDevOps-Public\\ReleaseScripts\\MyHealth.AKS.Release.json\"
    from the local Cloned Repo **Make sure you remove the trailing -Copy
    from your release definition name. Build definition should be named
    MyHealth.AKS.Release.**

2.  **Make sure you have placed the MyHealth.AKS.Release.json in a local
    folder.**

    ![](media/image7.png){width="4.928365048118986in"
    height="2.388888888888889in"}

3.  Edit the release definition delete the previous created
    MyHealth.AKS.build and add an artifact. Select MyHealth.AKS.build as
    **Source**, **Default version** should be **Latest** and Source
    Alias should be **MyHealth.AKS.build**. If you have another Artifact
    that gives you an error about project access, please delete. Make
    sure that the agents selected for each task is a **Hosted Agents**
    **(windows 2019)**.

    ![](media/image8.png){width="5.356629483814523in"
    height="2.589718941382327in"}

4.  **Edit** the release definition for **MyHealth.AKS.Release** and
    click on the **Tasks** tab.

    ![](media/image9.png){width="5.16517060367454in"
    height="2.6638888888888888in"}

5.  In the **Dev** stage, under the **DB deployment** phase, click on
    the **Execute Azure SQL: DacpacTask** task. Under **Azure Service
    Connection Type**, select from the drop down **Azure Resource
    Manager**. Under **Azure Subscription**, select your Azure
    subscription.

6.  Under the AKS deployment phase, for the Create Deployments &
    Services in AKS task, update the following fields based on the
    resources you created in the preparation lab:

    a.  Azure Subscription,

    b.  Resource group,

    c.  Kubernetes cluster.

    d.  Expand the Secrets section and update the parameters for Azure
        subscription from the dropdown.

        Click on the Update image in AKS task and repeat the same steps
        as above.

        ![](media/image10.png){width="5.041666666666667in"
        height="2.1187839020122485in"}

7.  Expand the **Secrets** area and use the following values for your
    **Secrets** section **except for the Azure Container Registry**.
    Here you will use the name you defined in the prerequisites
    document.

    ![](media/image11.png){width="6.0in" height="3.270138888888889in"}

8.  The tasks configured in **Step 5** are used to automate the
    following process:

    e.  **Create Deployments & Services in AKS** will create the
        deployments and services in AKS as per the configuration
        specified in **mhc-aks.yaml** file. The Pods will pull up the
        latest docker image when they are created.

    f.  **Update image in AKS** will pull up the appropriate image
        corresponding to the BuildID from the repository specified, and
        deploys the docker image to the **mhc-front pod** running in
        AKS.

    g.  A secret called **mysecretkey** is created in the AKS cluster
        through a kubectl command run by the pipeline in the background.
        This secret will be used for authorization while pulling
        myhealth.web image from the Azure Container Registry.

9.  Select the **Variables** tab and update the values for **ACR** and
    **SQLserver** for **Pipeline Variables** with the details noted
    earlier when preparing the lab environment. Click **Save** and press
    **OK** on the Save dialog to save the changes you made to the
    pipeline. Ignore third point in the picture below.

    ![](media/image12.png){width="6.0in" height="2.3048611111111112in"}

Exercise 1.3: Trigger a Build and Deploy the application
--------------------------------------------------------

#### Objectives

After completing this exercise, you will be able to:

-   Configure an Azure DevOps pipeline

#### Prerequisites

Completion of the Exercise 1.1 and 1.2

#### Scenario

In this exercise, let us trigger a build manually and upon completion,
an automatic deployment of the application will be triggered. Our
application is designed to be deployed in a Kubernetes pod with the load
balancer in the front-end and Redis cache in the back-end.

1.  Select **Pipelines** in the left navigation bar and under
    the **Builds** section click on the **Queue** button.
    Click **Queue** again when the window titled \"Queue build for
    MyHealth.AKS.build\" pops up.

    ![](media/image13.png){width="6.0in" height="1.9458333333333333in"}

2.  Once the build process starts, click on the link **Updated
    appsettings.json** to see the build in progress.

    ![](media/image14.png){width="4.44564523184602in"
    height="2.2023807961504813in"}

3.  The build will generate and push the docker image to ACR. After the
    build is completed, you will see the build summary. To view the
    generated images in the Azure Portal, select the **Azure Container
    Registry** and navigate to the **Repositories**.

    ![](media/image15.png){width="5.291666666666667in"
    height="2.506192038495188in"}

4.  Switch back to the Azure DevOps portal. Select the **Release** tab
    in the **Pipelines** section and single-click on the latest release.
    Select **In progress** link to see the live logs and release
    summary.

    ![](media/image16.png){width="6.0in" height="3.0840277777777776in"}

5.  Once the release is complete, go to Azure Shell and run the below
    commands to see the pods running in AKS:

    a.  ![](media/image17.png){width="6.0in"
        height="1.7666666666666666in"}Type **az login** in the command
        prompt and press Enter. Authenticate yourself by entering your
        credentials in the web browser that automatically opens up.

    b.  Type **az account show** to see the active subscription you are
        connected to. If it is not the right one, type **az account set
        \--subscription \[name or id\]**, replacing name or id with the
        one for the right subscription, which you can find in the list
        generated when running the command **az login** above.

    c.  Type **ku** in the command prompt to get the access credentials
        for the Kubernetes cluster. Replace the
        variables **yourResourceGroup** and **yourAKSname** with the
        actual values.

        ![](media/image18.png){width="5.552083333333333in"
        height="0.5729166666666666in"}

    d.  Type **kubectl get pods** to see the pods that are running (if
        the command is not recognized make sure that you set the
        installation folder for kubectl.exe into your environment PATH
        variable):

        ![](media/image19.png){width="4.822916666666667in"
        height="0.8541666666666666in"}

        The deployed web application is running in the displayed pods.
        Make sure both **STATUS** is \"Running\".

6.  To see what external IP address the application is using, run the
    below command. If you see that **External-IP** is pending, wait for
    sometime until an IP is assigned.

> **kubectl get service mhc-front \--watch**

![](media/image20.png){width="6.0in" height="0.7381944444444445in"}

7.  Copy the External-IP and paste it in the browser and press the Enter
    button to launch the application.

8.  **Access AKS through the browser** Type the below command in the
    command prompt to access the AKS through the browser.

    ![](media/image21.png){width="6.0in"
    height="1.6722222222222223in"}**az aks browse \--resource-group
    YourResourceGroup \--name yourAKSname**

9.  Once the **AKS Dashboard** is launched, the following details will
    be displayed.

    ![](media/image22.png){width="6.0in" height="3.0476192038495187in"}
