# Vulnerable Components

The challenges in this chapter are all about security issues of
libraries or other 3rd party components the application uses internally.

## Challenges covered in this chapter

| Name                   | Description                                                                                                                                              | Difficulty |
|:-----------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------|
| Arbitrary File Write   | Overwrite the Legal Information file.                                                                                                                    | ⭐⭐⭐⭐⭐⭐  |
| Forged Signed JWT      | Forge an almost properly RSA-signed JWT token that impersonates the (non-existing) user _rsa_lord@juice-sh.op_.                                          | ⭐⭐⭐⭐⭐⭐  |
| Frontend Typosquatting | Inform the shop about a typosquatting imposter that dug itself deep into the frontend. (Mention the exact name of the culprit)                           | ⭐⭐⭐⭐⭐    |
| Legacy Typosquatting   | Inform the shop about a typosquatting trick it has been a victim of at least in `v6.2.0-SNAPSHOT`. (Mention the exact name of the culprit)               | ⭐⭐⭐⭐     |
| Supply Chain Attack    | Inform the development team about a danger to some of _their_ credentials. (Send them the URL of the _original report_ or the CVE of this vulnerability) | ⭐⭐⭐⭐⭐    |
| Unsigned JWT           | Forge an essentially unsigned JWT token that impersonates the (non-existing) user _jwtn3d@juice-sh.op_.                                                  | ⭐⭐⭐⭐⭐    |
| Vulnerable Library     | Inform the shop about a vulnerable library it is using. (Mention the exact library name and version in your comment)                                     | ⭐⭐⭐⭐     |

### Overwrite the Legal Information file

> Uploaded files represent a significant risk to applications. The first
> step in many attacks is to get some code to the system to be attacked.
> Then the attack only needs to find a way to get the code executed.
> Using a file upload helps the attacker accomplish the first step.
>
> The consequences of unrestricted file upload can vary, including
> complete system takeover, an overloaded file system or database,
> forwarding attacks to back-end systems, client-side attacks, or simple
> defacement. It depends on what the application does with the uploaded
> file and especially where it is stored.
>
> There are really two classes of problems here. The first is with the
> file metadata, like the path and file name. These are generally
> provided by the transport, such as HTTP multi-part encoding. This data
> may trick the application into overwriting a critical file or storing
> the file in a bad location. You must validate the metadata extremely
> carefully before using it.
>
> The other class of problem is with the file size or content. The range
> of problems here depends entirely on what the file is used for. See
> the examples below for some ideas about how files might be misused. To
> protect against this type of attack, you should analyse everything
> your application does with files and think carefully about what
> processing and interpreters are involved.[^3]

* Find all places in the application where file uploads are possible.
* For at least one of these, the Juice Shop is depending on a library
  that suffers from an arbitrary file overwrite vulnerability.
* You can find a hint toward the underlying vulnerability in the
  [@owasp_juiceshop](https://twitter.com/owasp_juiceshop) Twitter
  timeline

### Forge an almost properly RSA-signed JWT token

Like
[Forge an essentially unsigned JWT token](#forge-an-essentially-unsigned-jwt-token)
this challenge requires you to make a valid JWT for a user that does not
exist. What makes this challenge even harder is the requirement to have
the JWT look like it was properly signed.

* The three generic hints from
  [Forge an essentially unsigned JWT token](#forge-an-essentially-unsigned-jwt-token)
  also help with this challenge.
* Instead of enforcing no encryption to be applied, try to apply a more
  sophisticated exploit against the JWT libraries used in the Juice
  Shop.
* Getting your hands on the public RSA key the application employs for
  its JWTs is mandatory for this challenge.
* Finding the corresponding private key should actually be impossible,
  but that obviously doesn't make this challenge unsolvable.
* Make sure your JWT is URL safe!

### Inform the shop about a typosquatting imposter that dug itself deep into the frontend

> Typosquatting, also called URL hijacking, a sting site, or a fake URL,
> is a form of cybersquatting, and possibly brandjacking which relies on
> mistakes such as typos made by Internet users when inputting a website
> address into a web browser. Should a user accidentally enter an
> incorrect website address, they may be led to any URL (including an
> alternative website owned by a cybersquatter).
>
> The typosquatter's URL will usually be one of four kinds, all similar
> to the victim site address (e.g. example.com):
>
> * A common misspelling, or foreign language spelling, of the intended
>   site: exemple.com
> * A misspelling based on typos: examlpe.com
> * A differently phrased domain name: examples.com
> * A different top-level domain: example.org
> * An abuse of the Country Code Top-Level Domain (ccTLD): example.cm by
>   using .cm, example.co by using .co, or example.om by using .om. A
>   person leaving out a letter in .com in error could arrive at the
>   fake URL's website.
>
> Once in the typosquatter's site, the user may also be tricked into
> thinking that they are in fact in the real site, through the use of
> copied or similar logos, website layouts or content. Spam emails
> sometimes make use of typosquatting URLs to trick users into visiting
> malicious sites that look like a given bank's site, for instance.[^1]

This challenge is about identifying and reporting (via the
https://owaspappXXXXXt10/#/contact form) a case of typosquatting hidden in
the Juice Shop. It is supposedly hard to locate.

* This challenge has nothing to do with URLs or domains.
* Other than for
  [its legacy companion](#inform-the-shop-about-a-typosquatting-trick-it-has-been-a-victim-of),
  combing through the `package.json.bak` does not help for this
  challenge.

ℹ️ There is no actual malice or mischief included, as the typosquatter
is completely harmless. Just keep in mind that in reality, a case like
this could come with negative consequences and would sometimes be even
harder to identify.

### Inform the shop about a typosquatting trick it has been a victim of

This challenge is about identifying and reporting (via the
https://owaspappXXXXXt10/#/contact form) a case of typosquatting that
successfully sneaked into an older version of the Juice Shop. Luckily,
it is not in use any more in {{book.juiceShopVersion}}.

* Just like
  [its frontend companion](#inform-the-shop-about-a-typosquatting-imposter-that-dug-itself-deep-into-the-frontend)
  this challenge also has nothing to do with URLs or domains.
* Investigating the
  [forgotten developer's backup file](sensitive-data-exposure.md#access-a-developers-forgotten-backup-file)
  might bring some insight.
* [Malicious packages in npm](https://iamakulov.com/notes/npm-malicious-packages/)
  is a worthwhile read on [Ivan Akulov’s blog](https://iamakulov.com).

### Inform the development team about a danger to some of their credentials

> A software supply chain attack is when an attacker gains access to a
> legitimate software vendor and then compromises either the software or
> update repository. This is done with the intention of installing a
> backdoor, or other malicious code, into the legitimate software update
> provided by the vendor. As users update their software, unwittingly
> falling victim to the Trojanized update, they also install the
> embedded malicious code.[^4]

ℹ️ Please note that having the OWASP Juice Shop installed on your
computer _does not_ put you at any actual risk! This challenge does
_neither_ install a backdoor or Trojan nor does it bring any other
harmful code to your system!

* The shop's end users are not the targets here. The developers of the
  shop are!
* This is a research-heavy challenge which does not involve any actual
  hacking.
* Solving
  [Access a developer's forgotten backup file](sensitive-data-exposure.md#access-a-developers-forgotten-backup-file)
  before attempting this challenge will save you from a lot of
  frustration.

### Forge an essentially unsigned JWT token

> JSON Web Token (JWT) is a compact, URL-safe means of representing
> claims to be transferred between two parties. The claims in a JWT are
> encoded as a JSON object that is used as the payload of a JSON Web
> Signature (JWS) structure or as the plaintext of a JSON Web Encryption
> (JWE) structure, enabling the claims to be digitally signed or
> integrity protected with a Message Authentication Code (MAC) and/or
> encrypted.[^2]

This challenge involves forging a valid JWT for a user that does not
exist in the database but make the application believe it is still
legit.

* You should begin with retrieving a valid JWT from the application's
  `Authorization` request header.
* A JWT is only given to users who have logged in. They have a limited
  validity, so better do not dawdle.
* Try to convince the site to give you a _valid_ token with the required
  payload while downgrading to _no_ encryption at all.
* Make sure your JWT is URL safe!

### Inform the shop about a vulnerable library it is using

This challenge is quite similar to
[Inform the shop about an algorithm or library it should definitely not use the way it does](cryptographic-issues.md#inform-the-shop-about-an-algorithm-or-library-it-should-definitely-not-use-the-way-it-does)
with the difference, that here not the _general use_ of the library is
the issue. The application is just using _a version_ of a library that
contains known vulnerabilities.

* Use the _Contact Us_ form to submit a feedback mentioning the
  vulnerable library including its exact version.
* Look for possible dependencies related to security in the
  `package.json.bak` you probably harvested earlier during the
  [Access a developer's forgotten backup file](sensitive-data-exposure.md#access-a-developers-forgotten-backup-file)
  challenge.
* Do some research on the internet for known security issues in the most
  suspicious application dependencies.

[^1]: https://en.wikipedia.org/wiki/Typosquatting
[^2]: https://tools.ietf.org/html/rfc7519
[^3]: https://www.owasp.org/index.php/Unrestricted_File_Upload
[^4]: https://www.rsa.com/en-us/blog/2017-02/are-software-supply-chain-attacks-the-new-norm
