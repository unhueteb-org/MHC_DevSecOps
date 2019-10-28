# Secure DevOps and Web Application Security

**Module 5: Threat Modeling**

Student Lab Manual

[[_TOC_]]

**Introduction**

Threat modeling is a core discipline of any SDL.

**Objectives**

After completing this lab, you will be able to:

- Use Microsoft's threat modeling tool to create threat models for
    enterprise scenarios.

**Prerequisites**

This lab requires the Threat Modeling tool which should already be
installed on your VM, if not please download the tool from
<https://aka.ms/threatmodelingtool>.

**Estimated Time to Complete This Lab**

60 minutes

For More Information

<https://www.microsoft.com/en-us/securityengineering/sdl/threatmodeling>

<https://aka.ms/threatmodelingtool>

## Lab 1: Threat Model

**Scenario**

In this exercise, you will learn how to create a threat model for a
simple Azure hosted web application.

1. The application is in App Service Environment with VNET integration.

2. It is protected by Azure Application gateway with WAF

3. It uses AAD authentication for users

4. It needs to start credit card numbers (Primary account number - "PAN")

5. It stores its data in Cosmos DB and Azure SQL

6. It connects to an on-prem web service (rest full) via ExpressRoute.

## Exercise 1: Threat Model

### Task 1: Create Diagram

1. Enter the elements above into the threat modeling tool.

2. Draw Active Flows only in the direction of control (do not diagram
    responses)

3. Draw trust boundaries, such as Azure, VNETs, On-Prem Datacenter

### Task 2: Generate Threats

1. Switch to Analysis view (in View menu)

2. View the generated threats

### Task 3: Mitigate Threats

1. Work through some of the mitigations (as time permits)
