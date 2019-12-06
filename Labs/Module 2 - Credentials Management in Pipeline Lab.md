---
title: Secure DevOps and Web Application Security
---

# Secure DevOps and Web Application Security

Module 2 - Credentials Management in Pipeline Lab

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

## Lab 1: Configure secrets your Azure DevOps Pipelines

**Introduction**

The development team want to integrate bests practices in credential management and avoid passwords 
stored in source control and the system.

The requirement is that the SecInfo team can specify new passwords and certificates in a centralized system.
This lab gives you a safe way to store and consume credentials from the Azure Key Vault.

**Objectives**

After completing this lab, you will be able to:

  - Configure an Azure Key Vault in Azure DevOps Pipeline

  - Secure your application with a secret management safe and reliable

**Prerequisites**

Completion of the Module 1: Creating a DevOps Pipeline.

**Estimated Time to Complete This Lab**

20 minutes

### Exercise 1.1: Configure Build and Release Pipeline

**Objectives**

After completing this exercise, you will be able to:

  - Configure Key Vault in Azure DevOps pipeline

**Scenario**

In this exercise, you will configure a Build Pipeline and Release that will
get Passwords from a KeyVault and publish artifacts for the Release Pipeline to deploy in production.

#### Task 1: Link Azure Key Vault to Azure DevOps Pipeline 

1.  Navigate to Pipelines-->Library in https://dev.azure.com and click `+ Variable group`

    ![Key vault](./Images/Module2-CreateKeyVault01.png)

2.  In the `Variable group name` field type `SecurityKeyVault`, then

    a) Swhitch the `Link secrets from Azure key vault as variables` to On.
    b) Select your Azure subscription.
    c) Select your Azure Key Vault and click in `Autorize` button.

    > If asked type your outlook accont and password
     
    ![Key vault](./Images/Module2-CreateKeyVault02.png)

3.  Click on `+ Add` in the current page, select `SQLpassword` and click `Ok`

    ![Key vault](./Images/Module2-CreateKeyVault03.png)

    > Save your Security group

     ![Key vault](./Images/Module2-CreateKeyVault04.png)


4.  Go Back to Library open the `DevSecOpsVariable` variable group, and delete the variable named `SQLpassword` in the list.

    ![Key vault](./Images/Module2-CreateKeyVault05.png)

    > Save your change

#### Task 2: Configure Release Pipeline to use the New Key Vault from Variable Group 

1.  Go back to Releases and edit your Release 
 
    ![](./Images/Module2-CreateKeyVaultRelease01.png)

2.  Select the `Variables` tab then `Variable group`, and click in `Link variable group`


    ![](./Images/Module2-CreateKeyVaultRelease02.png)

3.  Select `SecurityKeyVault(1)` variable group and click `Link`

    ![](./Images/Module2-CreateKeyVaultRelease03.png)
     
    ![](./Images/Module2-CreateKeyVaultRelease04.png)

    > Click in `Save`
    > 
    > The password will be used to update the database on the back-end
    > We don't save passwords in Source code anymore, and any security officer can setup the new Password in a secure way

#### Task 3: Configue the Build Pipeline to use the New Key Vault from Variable Group 

1.  Go back to Builds and edit your Build 
 
    ![](./Images/Module2-CreateKeyVault06.png)

2.  Select the `Variables` tab then `Variable group`, and click in `Link variable group`


    ![](./Images/Module2-CreateKeyVault07.png)

3.  Select `SecurityKeyVault(1)` variable group and click `Link`

    ![](./Images/Module2-CreateKeyVault08.png)
     
    ![](./Images/Module2-CreateKeyVault09.png)

    > Click in `Save & queue`
    > 
    >If you configured the `Continuous Deployment` on the previous lab, a new deployment will be triggered at the end of the build
    > 
    >Now the replace token task will use the new Password coming from Azure Key Vault at the build stage
    > We don't have passwords stored in Source code anymore, and any security officer can setup the new Password in a secure way
    
    ![](./Images/Module2-CreateKeyVault10.png)


4.  Wait for the release to be completed and confirm that the website is running.

    ![](./Images/Module1-AzureResultAKSShowPortsAKS_Site.png)
