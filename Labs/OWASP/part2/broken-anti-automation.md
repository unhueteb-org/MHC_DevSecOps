# Broken Anti-Automation

> Web applications are subjected to unwanted automated usage – day in,
> day out. Often these events relate to misuse of inherent valid
> functionality, rather than the attempted exploitation of unmitigated
> vulnerabilities. Also, excessive misuse is commonly mistakenly
> reported as application denial-of-service (DoS) like HTTP-flooding,
> when in fact the DoS is a side-effect instead of the primary intent.
> Frequently these have sector-specific names. Most of these problems
> seen regularly by web application owners are not listed in any OWASP
> Top Ten or other top issue list. Furthermore, they are not enumerated
> or defined adequately in existing dictionaries. These factors have
> contributed to inadequate visibility, and an inconsistency in naming
> such threats, with a consequent lack of clarity in attempts to address
> the issues. [^1]

## Challenges covered in this chapter

| Name                   | Description                                                                                                     | Difficulty |
|:-----------------------|:----------------------------------------------------------------------------------------------------------------|:-----------|
| CAPTCHA Bypass         | Submit 10 or more customer feedbacks within 10 seconds.                                                         | ⭐⭐⭐       |
| Extra Language         | Retrieve the language file that never made it into production.                                                  | ⭐⭐⭐⭐⭐    |
| Multiple Likes         | Like any review at least three times as the same user.                                                          | ⭐⭐⭐⭐⭐⭐  |
| Reset Morty's Password | Reset Morty's password via the Forgot Password mechanism with _his obfuscated answer_ to his security question. | ⭐⭐⭐⭐⭐    |

### Submit 10 or more customer feedbacks within 10 seconds

The _Contact Us_ form for customer feedback contains a CAPTCHA to
protect it from being abused through scripting. This challenge is about
beating this automation protection.

> A completely automated public Turing test to tell computers and humans
> apart, or CAPTCHA, is a program that allows you to distinguish between
> humans and computers. First widely used by Alta Vista to prevent
> automated search submissions, CAPTCHAs are particularly effective in
> stopping any kind of automated abuse, including brute-force attacks.
> They work by presenting some test that is easy for humans to pass but
> difficult for computers to pass; therefore, they can conclude with
> some certainty whether there is a human on the other end.
>
> For a CAPTCHA to be effective, humans must be able to answer the test
> correctly as close to 100 percent of the time as possible. Computers
> must fail as close to 100 percent of the time as possible.[^2]

* You could prepare 10 browser tabs, solving every CAPTCHA and filling
  out the each feedback form. Then you'd need to very quickly switch
  through the tabs and submit the forms in under 10 seconds total.
* Should the Juice Shop ever decide to change the challenge into
  _"Submit 100 or more customer feedbacks within 60 seconds"_ or worse,
  you'd probably have a hard time keeping up with any tab-switching
  approach.
* Investigate closely how the CAPTCHA mechanism works and try to find
  either a bypass or some automated way of solving it dynamically.
* Wrap this into a script (in whatever programming language you prefer)
  that repeats this 10 times.

### Retrieve the language file that never made it into production

> A project is internationalized when all of the project’s materials and
> deliverables are consumable by an international audience. This can
> involve translation of materials into different languages, and the
> distribution of project deliverables into different countries.[^3]

Following this requirement OWASP sets for all its projects, the Juice
Shop's user interface is available in different languages. One extra
language is actually available that you will not find in the selection
menu.

![Language selection dropdown](/part3/img/languages.png)

* First you should find out how the languages are technically changed in
  the user interface.
* Guessing will most definitely not work in this challenge.
* You should rather choose between the following two ways to beat this
  challenge:
  * _Apply brute force_ (and don't give up to quickly) to find it.
  * _Investigate online_ what languages are actually available.

> A brute force attack can manifest itself in many different ways, but
> primarily consists in an attacker configuring predetermined values,
> making requests to a server using those values, and then analyzing the
> response. For the sake of efficiency, an attacker may use a dictionary
> attack (with or without mutations) or a traditional brute-force attack
> (with given classes of characters e.g.: alphanumerical, special, case
> (in)sensitive). Considering a given method, number of tries,
> efficiency of the system which conducts the attack, and estimated
> efficiency of the system which is attacked the attacker is able to
> calculate approximately how long it will take to submit all chosen
> predetermined values.[^4]

### Like any review at least three times as the same user

Any online shop with a review or rating functionality for its products
should be very keen on keeping fake or inappropriate reviews out. The
Juice Shop decided to give its customers the ability to give a "like" to
their favorite reviews. Of course, each user should be able to do so
only once for each review.

* Every user is (almost) immediately associated with the review they
  "liked" to prevent abuse of that functionality
* Did you really think clicking the "like" button three times in a row
  _really fast_ would be enough to solve a ⭐⭐⭐⭐⭐⭐ challenge?
* The underlying flaw of this challenge is a Race Condition

> A race condition or race hazard is the behavior of an electronics,
> software, or other system where the output is dependent on the
> sequence or timing of other uncontrollable events. It becomes a bug
> when events do not happen in the order the programmer intended.[^5]

<!-- -->

> Many software race conditions have associated computer security
> implications. A race condition allows an attacker with access to a
> shared resource to cause other actors that utilize that resource to
> malfunction, resulting in effects including denial of service and
> privilege escalation.
>
> A specific kind of race condition involves checking for a predicate
> (e.g. for authentication), then acting on the predicate, while the
> state can change between the time of check and the time of use. When
> this kind of bug exists in security-sensitive code, a security
> vulnerability called a time-of-check-to-time-of-use (TOCTTOU) bug is
> created.[^6]

### Reset Morty's password via the Forgot Password mechanism

This password reset challenge is different from those from the
[Broken Authentication](broken-authentication.md) category as it is next
to impossible to solve without using a brute force approach.

* Finding out who Morty actually is, will help to reduce the solution
  space.
* You can assume that Morty answered his security question truthfully
  but employed some obfuscation to make it more secure.
* Morty's answer is less than 10 characters long and does not include
  any special characters.
* Unfortunately, _Forgot your password?_ is protected by a rate limiting
  mechanism that prevents brute forcing. You need to beat this somehow.

[^1]: https://www.owasp.org/index.php/OWASP_Automated_Threats_to_Web_Applications
[^2]: https://www.owasp.org/index.php/Blocking_Brute_Force_Attacks#Sidebar:_Using_CAPTCHAS
[^3]: https://www.owasp.org/index.php/OWASP_2014_Project_Handbook#tab=Project_Requirements
[^4]: https://www.owasp.org/index.php/Brute_force_attack
[^5]: https://en.wikipedia.org/wiki/Race_condition
[^6]: https://en.wikipedia.org/wiki/Race_condition#Computer_security
