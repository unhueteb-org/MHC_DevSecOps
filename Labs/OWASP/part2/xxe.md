# XML External Entities (XXE)

> An XML External Entity attack is a type of attack against an
> application that parses XML input. This attack occurs when XML input
> containing a reference to an external entity is processed by a weakly
> configured XML parser. This attack may lead to the disclosure of
> confidential data, denial of service, server side request forgery,
> port scanning from the perspective of the machine where the parser is
> located, and other system impacts.
>
> The XML 1.0 standard defines the structure of an XML document. The
> standard defines a concept called an entity, which is a storage unit
> of some type. There are a few different types of entities, external
> general/parameter parsed entity often shortened to external entity,
> that can access local or remote content via a declared system
> identifier. The system identifier is assumed to be a URI that can be
> dereferenced (accessed) by the XML processor when processing the
> entity. The XML processor then replaces occurrences of the named
> external entity with the contents dereferenced by the system
> identifier. If the system identifier contains tainted data and the XML
> processor dereferences this tainted data, the XML processor may
> disclose confidential information normally not accessible by the
> application. Similar attack vectors apply the usage of external DTDs,
> external stylesheets, external schemas, etc. which, when included,
> allow similar external resource inclusion style attacks.
>
> Attacks can include disclosing local files, which may contain
> sensitive data such as passwords or private user data, using file:
> schemes or relative paths in the system identifier. Since the attack
> occurs relative to the application processing the XML document, an
> attacker may use this trusted application to pivot to other internal
> systems, possibly disclosing other internal content via http(s)
> requests or launching a CSRF attack to any unprotected internal
> services. In some situations, an XML processor library that is
> vulnerable to client-side memory corruption issues may be exploited by
> dereferencing a malicious URI, possibly allowing arbitrary code
> execution under the application account. Other attacks can access
> local resources that may not stop returning data, possibly impacting
> application availability if too many threads or processes are not
> released.
>
> Note that the application does not need to explicitly return the
> response to the attacker for it to be vulnerable to information
> disclosures. An attacker can leverage DNS information to exfiltrate
> data through subdomain names to a DNS server that he/she controls.[^1]

## Challenges covered in this chapter

| Name            | Description                                                                       | Difficulty |
|:----------------|:----------------------------------------------------------------------------------|:-----------|
| XXE Data Access | Retrieve the content of `C:\Windows\system.ini` or `/etc/passwd` from the server. | ⭐⭐⭐       |
| XXE DoS         | Give the server something to chew on for quite a while.                           | ⭐⭐⭐⭐⭐    |

ℹ️ _Please note that both XXE challenges described below are **not
available** when running the Juice Shop in either a Docker container or
on a Heroku dyno! Certain aggressive attacks against the underlying XML
parser caused the process to die from "Segmentation Fault" (`segfault`)
errors. This happens despite the fact that the parsing actually happens
in a sandbox with a timeout. While it is unfortunate to not have XXE
challenges on containerized environments, this somewhat nicely shows how
incredibly dangerous ill-configured XML parsers actually are._

### Retrieve the content of C:\Windows\system.ini or /etc/passwd from the server

In this challenge you are tasked to disclose a local file from the
server the Juice Shop backend is hosted on.

* You already found the leverage point for this challenge if you solved
  [Use a deprecated B2B interface that was not properly shut down](security-misconfiguration.md#use-a-deprecated-b2b-interface-that-was-not-properly-shut-down).
* This challenge sounds a lot harder than it actually is, which
  amplifies how bad the underlying vulnerability is.
* Doing some research on typical XEE attack patterns basically gives
  away the solution for free.

### Give the server something to chew on for quite a while

Similar to
[Let the server sleep for some time](injection.md#let-the-server-sleep-for-some-time)
this challenge is about performing a stripped-down _denial-of-service_
attack. But this one is going against an entirely different leverage
point.

* The leverage point for this is obviously the same as for the
  [XXE Tier 1](#retrieve-the-content-of-cwindowssystemini-or-etcpasswd-from-the-server)
  challenge above.
* You can only solve this challenge by keeping the server busy for >2sec
  with your attack.
* The effectiveness of attack payloads for this challenge might depend
  on the operating system the Juice Shop is running on.

[^1]: https://www.owasp.org/index.php/XML_External_Entity_(XXE)_Processing

