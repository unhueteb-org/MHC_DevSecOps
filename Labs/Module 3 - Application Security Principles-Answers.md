# Secure DevOps and Web Application Security

**Module 3: Application Security Principles**

Student Lab Manual

[[_TOC_]]

**Introduction**

In this lab, students will analyze the Contoso Times web application for
security design errors and vulnerabilities.

**Objectives** 

After completing this lab, students will be able to:

- Familiarize themselves with common vulnerabilities in web
    applications.

**Prerequisites**

This lab requires IIS and SQL Server Express in order to run the web
application.

**Estimated time to complete this lab**

45 Minutes (30 Minutes code review- 15 Minute discussion)

## List of Vulnerabilities

  1. Database Username/Password in web.config file without encryption.

  2. Use SQL Server authentication instead of windows authentication in web.config.

  3. SQL user has "sysadmin" rights. Check with SQL Server Management
    Studio.

  4. Exceptions with details. \<customErrors mode=\"Off\"\> production environment.

  5. String concatenation in SQL queries (SQL Injection)

  6. Input sanitation.

  7. Storing passwords in plaintext in SQL database.

  8. JavaScript validation.

  9. User credentials are transmitted in plain text over the network;
    hence, susceptible to network sniffing.

  10. Cross-site scripting attack.

  11. Complex password

  12. Database user ID is released

  13. No logging

  14. Password-guessing attack: There is no locking after a number of
    failed attempts.
