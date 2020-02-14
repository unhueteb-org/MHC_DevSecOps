# Secure DevOps and Web Application Security

**Module 3: Application Security Principles**

Student Lab Manual

[[_TOC_]]

## Lab 1: Investigate Security Vulnerabilities

**Introduction**

In this lab, you will investigate security vulnerabilities in a web
application and discuss with the instructor on how to resolve them.

**Objectives**

After completing this lab, you will be able to:

- Understand common security design vulnerabilities

- Fix vulnerabilities

**Prerequisites**

**Estimated time to complete this lab**

30 Minutes

**Scenario**

- Use the website

- Review code for vulnerabilities

- Discuss your findings with class and instructor

### Exercise 1: Use the Web Site

**Objectives**

In this exercise, you will open the web project and browse the website.

**Prerequisites**

You must have Visual Studio installed in order to open the web project.
SQL Server Express is required to host the database.

#### Task 1: Open the Web Project

  1. Double click the Contoso Times.sln located in \\Users\\Student\\source\\repos\\Contoso Times.
     If the directory is not present, please clone project from https://dev.azure.com//securedevopsdelivery//_git/ContosoTimes

  2. Start the Web Application without debug

      ![Contoso](./Images/Module3-ContosoTimes.png)

  3. Contoso Times is a fictional news web site that you can read news.

  4. Click on a news in Travel category.

  5. You need to create an account to view the news in that category.

      ![Login](./Images/Module3-ContosoTimesLogin.png)

  6. Click "Not a member? Create an account" link.

  7. This will navigate you to the registration page.

  8. Create a new account for yourself with a username and password.

  9. Click "Login" link on the top right side of the page.

      ![Link to login](./Images/Module3-ContosoTimesLinkLogin.png)

  10. Enter the login information that you created.

  11. Click "Travel" category on the menu.

      ![Menu Contoso](./Images/Module3-ContosoTimesMenu.png)

  12. Read the second news in that category. Titled; "Airlines Announce Lowest European Fares Ever" by clicking "read more" link.

  13. Click the "Edit" link at the bottom of the page to edit the story.

      ![Contoso Text Body](./Images/Module3-ContosoTimesText.png)

  14. Change the title with "This is my title" and update the story.

  15. Navigate the same news and see your changes.

  16. Now click the "World" category.

  17. Open the first story in that category, titled "Bill Clinton Elected to British Parliament".

  18. Click on "Read more..." link for "Bill Clinton Elected to British Parliament" story.

  19. Click the "Edit" link at the bottom of the page to edit the story.

  20. Change the title as "Are you kidding?".

  21. Click "Update" button.

  22. What happened to the application? What do you see on the screen and why?

#### Task 2: Review the code

In this task, you will review the code and document the vulnerabilities that you find.

#### Task 3: Discuss your findings with class and instructor

In this task, you will discuss your findings with your colleagues and instructor.
