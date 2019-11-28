# Customization

One of the core usage scenarios for OWASP Juice Shop is in employee
trainings in order to facilitating security awareness. With its not
entirely serious user roster and product inventory the application might
not be suited for all audiences alike.

In some particularly traditional domains or conservative enterprises it
would be beneficial to have the demo application look and behave more
like an internal application.

OWASP Juice Shop can be customized in its product inventory and look &
feel to accommodate this requirement. It also allows to add an arbitrary
number of fake users to make demonstrations - particularly those of
`UNION-SQL` injection attacks - even more impressive. Furthermore the
Challenge solved!-notifications can be turned off in order to keep the
impression of a "real" application undisturbed.

## How to customize the application

The customization is powered by a YAML configuration file placed in
`/config`. To run a customized OWASP Juice Shop you need to:

1. Place your own `.yml` configuration file into `/config`
2. Set the environment variable `NODE_ENV` to the filename of your
   config without the `.yml` extension
   * On Windows: `set NODE_ENV=nameOfYourConfig`
   * On Linux: `export NODE_ENV=nameOfYourConfig`
3. Run `npm start`

You can also run a config directly in one command (on Linux) via
`NODE_ENV=nameOfYourConfig npm start`. By default the
`config/default.yml` config is used which generates the original OWASP
Juice Shop look & feel and inventory. Please note that it is not
necessary to run `npm install` after switching customization
configurations.

### Overriding `default.yml` in Docker container

In order to override the default configuration inside your Docker
container with one of the provided configs, you can pass in the
`NODE_ENV` environment variable with the `-e` parameter:

```bash
docker run -d -e "NODE_ENV=bodgeit" -p 3000:3000
```

In order to inject your own configuration, you can use `-v` to mount the
`default.yml` path inside the container to any config file on your
outside file system:

```bash
docker run -d -e "NODE_ENV=myConfig" -v /tmp/myConfig.yml:/juice-shop/config/myConfig.yml -p 3000:3000 --name juice-shop bkimminich/juice-shop
```

## YAML configuration file

The YAML format for customizations is very straightforward. Below you
find its syntax along with an excerpt of the default settings.

* `server`
  * `port` to launch the server on. Defaults to `3000`
* `application`
  * `domain` used for all user email addresses. Defaults to
    `'juice-sh.op'`
  * `name` as shown in title and menu bar Defaults to `'OWASP Juice
    Shop'`
  * `logo` filename in `frontend/dist/frontend/assets/public/images`
    _or_ a URL of an image which will first be download to that folder
    and then used as a logo. Defaults to `JuiceShop_Logo.png`
  * `favicon` filename in `frontend/dist/frontend/assets/public` _or_ a
    URL of an image in `.ico` format which will first be download to
    that folder and then used as a favicon. Defaults to `favicon_v2.ico`
  * `theme` the name of the color theme used to render the UI. Options
    are `bluegrey-lightgreen`, `blue-lightblue`, `deeppurple-amber`,
    `indigo-pink`, `pink-bluegrey`, `purple-green` and
    `deeporange-indigo`. Defaults to `bluegrey-lightgreen`
  * `showChallengeSolvedNotifications` shows or hides all instant
    _"challenge solved"_-notifications. Recommended to set to `false`
    for awareness demos. Defaults to `true`.
  * `showChallengeHints` shows or hides hints for each challenge on
    hovering over/clicking its _"unsolved"_ badge on the score board.
    Defaults to `true`.
  * `showVersionNumber` shows or hides the software version from the
    title. Defaults to `true`.
  * `showHackingInstructor` shows or hides
    [Hacking Instructor](challenges.md#hacking-instructor) buttons on
    the Score Board and in the Welcome Banner. Defaults to `true`.
  * `showGitHubLinks` shows or hides the _"GitHub"_ button in the
    navigation and side bar as well as the info box about contributing
    on the _Score Board_. Defaults to `true`.
  * `numberOfRandomFakeUsers` represents the number of random user
    accounts to be created on top of the pre-defined ones (which are
    required for several challenges). Defaults to `0`, meaning no
    additional users are created.
  * `twitterUrl` used as the Twitter link promising coupon codes on the
    _About Us_ and _Your Basket_ screen. Defaults to
    `'https://twitter.com/owasp_juiceshop'`
  * `facebookUrl` used as the Facebook link promising coupon codes on
    the _About Us_ and _Your Basket_ screen. Defaults to
    `'https://www.facebook.com/owasp.juiceshop'`
  * `slackUrl` used as the Slack link on the _About Us_ screen. Defaults
    to `'http://owaspslack.com'`
  * `pressKitUrl` used as the link to logos and media files on the
    _About Us_ screen. Defaults to
    `'https://github.com/OWASP/owasp-swag/tree/master/projects/juice-shop'`
  * `planetOverlayMap` filename in
    `frontend/dist/frontend/assets/private` _or_ URL of an image to
    download to that folder and then use as an overlay texture for the
    3D planet "easter egg". Defaults to `orangemap2k.jpg`
  * `planetName` of the 3D planet "easter egg" as shown in the page
    title. Defaults to `Orangeuze`
  * `deluxePage` custom elements on the _Deluxe Membership_ page
    * `deluxeDeliveryImage` filename in
      `frontend/dist/frontend/assets/public/images/deluxe` _or_ a URL of
      an image which will first be download to that folder and then
      displayed on the _Deluxe Membership_ page. Defaults to
      `delivery_juiceshop.png`.
  * `recyclePage` custom elements on the _Request Recycling Box_ page
    * `topProductImage` filename in
      `frontend/dist/frontend/assets/public/images/products` to use as
      the image on the top of the info column on the page. Defaults to
      `fruit_press.jpg`
    * `bottomProductImage` filename in
      `frontend/dist/frontend/assets/public/images/products` to use as
      the image on the bottom of the info column on the page. Defaults
      to `apple_pressings.jpg`
  * `altcoinName` defines the name of the (fake) crypto currency that is
    offered on the _Token Sale_ screen. Defaults to `Juicycoin`
  * `welcomeBanner` defines a dismissable welcome banner that can be
    shown when first visiting the application.
    * `showOnFirstStart` shows or hides the banner. Defaults to `true`.
    * `title` defines the headline of the banner. Defaults to `Welcome
      to OWASP Juice Shop!`.
    * `message` defines the body of the banner. Can contain arbitrary
      HTML. Defaults to `<p>Being a web application with a vast number
      of intended security vulnerabilities, the <strong>OWASP Juice
      Shop</strong> is supposed to be the opposite of a best practice or
      template application for web developers: It is an awareness,
      training, demonstration and exercise tool for security risks in
      modern web applications. The <strong>OWASP Juice Shop</strong> is
      an open-source project hosted by the non-profit <a
      href='https://owasp.org' target='_blank'>Open Web Application
      Security Project (OWASP)</a> and is developed and maintained by
      volunteers. Check out the link below for more information and
      documentation on the project.</p><h1><a
      href='https://owasp-juice.shop'
      target='_blank'>https://owasp-juice.shop</a></h1>`.
  * `cookieConsent` defines the cookie consent dialog shown in the
    bottom right corner
    * `backgroundColor` of the cookie banner itself. Defaults to
      `'#546e7a'`
    * `textColor` of the `message` shown in the cookie banner. Defaults
      to `'#ffffff'`
    * `buttonColor` defines the color of the button to dismiss the
      banner. Defaults to `'#558b2f'`
    * `buttonTextColor` of the `dismissText` on the button. Defaults to
      `'#ffffff'`
    * `message` explains the cookie usage in the application. Defaults
      to `'This website uses fruit cookies to ensure you get the
      juiciest tracking experience.'`
    * `dismissText` the text shown on the button to dismiss the banner.
      Defaults to `'Me want it!'`
    * `linkText` is shown after the `message` to refer to further
      information. Defaults to `'But me wait!'`
    * `linkUrl` provides further information about cookie usage.
      Defaults to `'https://www.youtube.com/watch?v=9PnbKL3wuH4'`
  * `privacyContactEmail` the email address shown as contact in the
    _Privacy Policy_. Defaults to `donotreply@owasp-juice.shop`
  * `securityTxt` defines the attributes for the `security.txt` file
    based on the <https://securitytxt.org/> Internet draft
    * `contact` an email address, phone number or URL to report security
      vulnerabilities to. Can be fake obviously. Defaults to
      `mailto:donotreply@owasp-juice.shop`
    * `encryption` URL to a public encryption key for secure
      communication. Can be fake obviously. Defaults to
      `https://keybase.io/bkimminich/pgp_keys.asc?fingerprint=19c01cb7157e4645e9e2c863062a85a8cbfbdcda`
    * `acknowledgements` URL a "hall of fame" page. Can be fake
      obviously. Defaults to `/#/score-board`
  * `promotion` defines the attributes required for the `/promotion`
    screen where a marketing video with subtitles is rendered that hosts
    the
    [XSS Tier 6](../part2/xss.md#embed-an-xss-payload-into-our-promo-video)
    challenge
    * `video` name of a file with `video/mp4` content type in
      `frontend/dist/frontend/assets/public/videos` _or_ URL of an image
      to download to that folder and then use as the promotion video.
      Defaults to `JuiceShopJingle.mp4`
    * `subtitles` name of a
      [Web Video Text Tracks Format](https://www.w3.org/TR/webvtt1/)
      file in `frontend/dist/frontend/assets/public/videos` _or_ URL of
      an image to download to that folder and then use as the promotion
      video. Defaults to `JuiceShopJingle.vtt`
* `challenges`
  * `safetyOverride` enables all
    [potentially dangerous challenges](challenges.md#potentially-dangerous-challenges)
    regardless of any harm they might cause when running in a
    containerized environment. Defaults to `false`
  * `overwriteUrlForProductTamperingChallenge` the URL that should
    replace the original URL defined in
    `urlForProductTamperingChallenge` for the
    [Product Tampering](../part2/broken-access-control.md#change-the-href-of-the-link-within-the-o-saft-product-description)
    challenge. Defaults to `https://owasp.slack.com`
* `products` list which, when specified, replaces **the entire list** of
  default products
  * `name` of the product (_mandatory_)
  * `description` of the product (_optional_). Defaults to a static
    placeholder text
  * `price` of the product (_optional_). Defaults to a random price
  * `image` (_optional_) filename in
    `frontend/dist/frontend/assets/public/images/products` _or_ URL of
    an image to download to that folder and then use as a product image.
    Defaults to `undefined.png`
  * `deletedDate` of the product in `YYYY-MM-DD` format (_optional_).
    Defaults to `null`.
  * `urlForProductTamperingChallenge` sets the original link of the
    product which is the target for the
    [Product Tampering](../part2/broken-access-control.md#change-the-href-of-the-link-within-the-o-saft-product-description)
    challenge. Overrides `deletedDate` with `null` (_must be defined on
    exactly one product_)
  * `useForChristmasSpecialChallenge` marks a product as the target for
    [the "christmas special" challenge](../part2/injection.md#order-the-christmas-special-offer-of-2014).
    Overrides `deletedDate` with `2014-12-27` (_must be `true` on
    exactly one product_)
  * `fileForRetrieveBlueprintChallenge` (_must be `true` on exactly one
    product_) filename in
    `frontend/dist/frontend/assets/public/images/products` _or_ URL of a
    file download to that folder and then use as the target for the
    [Retrieve Blueprint](../part2/sensitive-data-exposure.md#deprive-the-shop-of-earnings-by-downloading-the-blueprint-for-one-of-its-products)
    challenge. If a filename is specified but the file does not exist in
    `frontend/dist/frontend/assets/public/images/products` the challenge
    is still solvable by just requesting it from the server. Defaults to
    `JuiceShop.stl`. ℹ️ _To make this challenge realistically
    solvable, include some kind of hint to the blueprint file's
    name/type in the product image (e.g. its `Exif` metadata) or in the
    product description_
  * `keywordsForPastebinDataLeakChallenge` (_must be defined on exactly
    one product_) list of keywords which are all mandatory to mention in
    a feedback or complaint to solve the
    [DLP Tier 1](../part2/sensitive-data-exposure.md#identify-an-unsafe-product-that-was-removed-from-the-shop-and-inform-the-shop-which-ingredients-are-dangerous)
    challenge. Overrides `deletedDate` with `2019-02-1`. ℹ️ _To make
    this challenge realistically solvable, provide the keywords on e.g.
    PasteBin in an obscured way that works well with the "dangerous
    ingredients of an unsafe product"" narrative_
  * `reviews` a sub-list which adds reviews to a product (_optional_)
    * `text` of the review (_mandatory_)
    * `author` of the review from the following list of pre-defined
      users in the database: `admin`, `jim`, `bender`, `ciso`,
      `support`, `morty`, `amy`, `mc.safesearch`, `J12934`, `wurstbrot`
      or `bjoern` (_mandatory_)
* `memories` list which, when specified, replaces all default _Photo
  Wall_ entries
  * `image` filename in
    `frontend/dist/frontend/assets/public/images/uploads/` _or_ URL of
    an image to download to that folder and then use as a _Photo Wall_
    image (_mandatory_)
  * `caption` text to show when hovering over the image or sending a
    Tweet about it (_optional_)
  * `user` reference by `key` from `data/static/users.yml` to the owner
    of the photo upload (_mandatory_)
* `ctf`
  * `showFlagsInNotifications` shows or hides the CTF flag codes in the
    _"challenge solved"_-notifications. Is ignored when
    `application.showChallengeSolvedNotifications` is set to `false`.
    Defaults to `false`
  * `showCountryDetailsInNotifications` determines if the country mapped
    to the solved challenge is displayed in the notification. Can be
    `none`, `name`, `flag` or `both`. Only useful for CTFs using
    [FBCTF](ctf.md#running-fbctf). Defaults to `none`
  * `countryMapping` list which maps challenges to countries on the
    challenge map of [FBCTF](ctf.md#running-fbctf). Only needed for CTFs
    using [FBCTF](ctf.md#running-fbctf). Defaults to empty `~`
    * `<challengeName>`
      * `name` the name of the country
      * `code` the two-letter ISO code of the country

### Configuration example

```yaml
server:
  port: 3000
application:
  domain: juice-sh.op
  name: 'OWASP Juice Shop'
  logo: JuiceShop_Logo.png
  favicon: favicon_v2.ico
  theme: bluegrey-lightgreen
  showChallengeSolvedNotifications: true
  showChallengeHints: true
  showVersionNumber: true
  showHackingInstructor: true
  showGitHubLinks: true
  numberOfRandomFakeUsers: 0
  twitterUrl: 'https://twitter.com/owasp_juiceshop'
  facebookUrl: 'https://www.facebook.com/owasp.juiceshop'
  slackUrl: 'http://owaspslack.com'
  planetOverlayMap: orangemap2k.jpg
  planetName: Orangeuze
  deluxePage:
    deluxeDeliveryImage: delivery_juiceshop.png
  recyclePage:
    topProductImage: fruit_press.jpg
    bottomProductImage: apple_pressings.jpg
  altcoinName: Juicycoin
  welcomeBanner:
    showOnFirstStart: true
    title: 'Welcome to OWASP Juice Shop!'
    message: "<p>Being a web application with a vast number of intended security vulnerabilities, the <strong>OWASP Juice Shop</strong> is supposed to be the opposite of a best practice or template application for web developers: It is an awareness, training, demonstration and exercise tool for security risks in modern web applications. The <strong>OWASP Juice Shop</strong> is an open-source project hosted by the non-profit <a href='https://owasp.org' target='_blank'>Open Web Application Security Project (OWASP)</a> and is developed and maintained by volunteers. Check out the link below for more information and documentation on the project.</p><h1><a href='https://owasp-juice.shop' target='_blank'>https://owasp-juice.shop</a></h1>"
  cookieConsent:
    backgroundColor: '#eb6c44'
    textColor: '#ffffff'
    buttonColor: '#f5d948'
    buttonTextColor: '#000000'
    message: 'This website uses fruit cookies to ensure you get the juiciest tracking experience.'
    dismissText: 'Me want it!'
    linkText: 'But me wait!'
    linkUrl: 'https://www.youtube.com/watch?v=9PnbKL3wuH4'
  privacyContactEmail: donotreply@owasp-juice.shop
  securityTxt:
    contact: 'mailto:donotreply@owasp-juice.shop'
    encryption: 'https://pgp.mit.edu/pks/lookup?op=get&search=0x062A85A8CBFBDCDA'
    acknowledgements: '/#/score-board'
  promotion:
    video: JuiceShopJingle.mp4
    subtitles: jingleSubtitles.vtt
challenges:
  safetyOverride: false
  overwriteUrlForProductTamperingChallenge: 'https://owasp.slack.com'
products:
  -
    name: 'Apple Juice (1000ml)'
    price: 1.99
    description: 'The all-time classic.'
    image: apple_juice.jpg
    reviews:
      - { text: 'One of my favorites!', author: admin }
# ~~~~~ ... ~~~~~~
  -
    name: 'OWASP SSL Advanced Forensic Tool (O-Saft)'
    description: 'O-Saft is an easy to use tool to show information about SSL certificate and tests the SSL connection according given list of ciphers and various SSL configurations.'
    price: 0.01
    image: orange_juice.jpg
    urlForProductTamperingChallenge: 'https://www.owasp.org/index.php/O-Saft'
  -
    name: 'Christmas Super-Surprise-Box (2014 Edition)'
    description: 'Contains a random selection of 10 bottles (each 500ml) of our tastiest juices and an extra fan shirt for an unbeatable price!'
    price: 29.99
    image: undefined.jpg
    useForChristmasSpecialChallenge: true
  -
    name: 'OWASP Juice Shop Sticker (2015/2016 design)'
    description: 'Die-cut sticker with the official 2015/2016 logo. By now this is a rare collectors item. <em>Out of stock!</em>'
    price: 999.99
    image: sticker.png
    deletedDate: '2017-04-28'
# ~~~~~ ... ~~~~~~
  -
    name: 'OWASP Juice Shop Logo (3D-printed)'
    description: 'This rare item was designed and handcrafted in Sweden. This is why it is so incredibly expensive despite its complete lack of purpose.'
    price: 99.99
    image: 3d_keychain.jpg
    fileForRetrieveBlueprintChallenge: JuiceShop.stl
# ~~~~~ ... ~~~~~~
memories:
  -
    image: 'magn(et)ificent!-1571814229653.jpg'
    caption: 'Magn(et)ificent!'
    user: bjoernOwasp
ctf:
  showFlagsInNotifications: false
  showCountryDetailsInNotifications: none
  countryMapping: ~
```

### Overriding default settings

When creating your own YAML configuration file, you can rely on the
existing default values and only overwrite what you want to change. The
provided `config/ctf.yml` file for capture-the-flag events for example
is as short as this:

```yaml
application:
  logo: JuiceShopCTF_Logo.png
  favicon: favicon_ctf.ico
  showChallengeHints: false
  showVersionNumber: false
  showHackingInstructor: false
  showGitHubLinks: false
  deluxePage:
    deluxeDeliveryImage: delivery_ctf.png
  welcomeBanner:
    showOnFirstStart: false
ctf:
  showFlagsInNotifications: true
```

### Testing customizations

To verify if your custom configuration will not break any of the
challenges, you should run the end-to-end tests via `npm run
protractor`. If they pass, all challenges will be working fine!

## Provided customizations

The following three customizations are provided out of the box by OWASP
Juice Shop:
* [7 Minute Security](https://github.com/bkimminich/juice-shop/blob/master/config/7ms.yml):
  Full conversion <https://7ms.us>-theme for the first podcast that
  picked up the Juice Shop way before it was famous! 😎
* [Mozilla-CTF](https://github.com/bkimminich/juice-shop/blob/master/config/mozilla.yml):
  Another full conversion theme harvested and refined from the
  [Mozilla Austin CTF-event](https://hacks.mozilla.org/2018/03/hands-on-web-security-capture-the-flag-with-owasp-juice-shop)!
  🦊
* [AllDayDeflOps](https://github.com/bkimminich/juice-shop/blob/master/config/addo.yml):
  This full conversion had its live debut at the
  [All Day DevOps 2019](https://www.alldaydevops.com/) conference and
  was released the same day! 🎀
* [The BodgeIt Store](https://github.com/bkimminich/juice-shop/blob/master/config/bodgeit.yml):
  An homage to
  [our server-side rendered ancestor](https://github.com/psiinon/bodgeit).
  May it rest in JSPs! 💀
* [CTF-mode](https://github.com/bkimminich/juice-shop/blob/master/config/ctf.yml):
  Keeps the Juice Shop in its default layout but disabled hints while
  enabling CTF flag codes in the _"challenge solved"_-notifications.
  Refer to [Hosting a CTF event](ctf.md) to learn more about running a
  CTF-event with OWASP Juice Shop. 🚩
* [Quiet mode](https://github.com/bkimminich/juice-shop/blob/master/config/quiet.yml):
  Keeps the Juice Shop in its default layout but hides all _"challenge
  solved"_-notifications, GitHub ribbon and challenge hints. 🔇
* [OWASP Juice Box](https://github.com/bkimminich/juice-shop/blob/master/config/juicebox.yml):
  If you find _jo͞osbäks_ much easier to pronounce than _jo͞osSHäp_,
  this customization is for you. 🧃
* [Unsafe mode](https://github.com/bkimminich/juice-shop/blob/master/config/unsafe.yml):
  Keeps everything at default settings except _enabling_ all
  [potentially dangerous challenges](challenges.md#potentially-dangerous-challenges)
  even in containerized environments. ☠️ **Use at your own risk!**

![Mozilla-CTF theme](/part1/img/theme_mozilla.png)

![BodgeIt Store theme](/part1/img/theme_bodgeit.png)

## Limitations

* When running a customization (except `default.yml`) that overwrites
  the property `application.domain`, the description of the challenges
  _Ephemeral Accountant_, _Forged Signed JWT_ and _Unsigned JWT_ will
  always be shown in English.
* Configurations (except `default.yml`) do not support translation of
  custom product names and descriptions as of {{book.juiceShopVersion}}.

## Additional Browser tweaks

Consider you are doing a live demo with a highly customized corporate
theme. Your narrative is, that this _really_ is an upcoming eCommerce
application _of that company_. [Walking the "happy path"](happy-path.md)
might now lure you into two situations which could spoil the immersion
for the audience.

#### Coupon codes on social media

If you configured the `twitterUrl`/`facebookUrl` as the company's own
account/page, you will most likely not find any coupon codes posted
there. You will probably fail to convince the social media team to tweet
or retweet some coupon code for an application that does not even exist!

![Coupon Immersion Spoiler](/part1/img/coupon_immersion-spoiler.png)

#### OAuth Login

Another immersion spoiler occurs when demonstrating the _Log in with
Google_ functionality, which will show you the application name
registered on Google Cloud Platform: _OWASP Juice Shop_! There is no way
to convince Google to show anything else for obvious trust and integrity
reasons.

![OAuth Immersion Spoiler](/part1/img/oauth_immersion-spoiler.png)

### On-the-fly text replacement

You can solve both of the above problems _in your own Browser_ by
replacing text on the fly when the Twitter, Facebook or Google-Login
page is loaded. For Chrome
[Word Replacer II](https://chrome.google.com/webstore/detail/word-replacer-ii/djakfbefalbkkdgnhkkdiihelkjdpbfh?hl=en)
is a plugin that does this work for you with very little setup effort.
For Firefox
[FoxReplace](https://addons.mozilla.org/en-US/firefox/addon/foxreplace/)
does a similar job. After installing either plugin you have to create
two text replacements:

1. Create a replacement for `OWASP Juice Shop` (as it appears on
   Google-Login) with your own application name. Best use
   `application.name` from your configuration.
2. Create another replacement for a complete or partial Tweet or
   Facebook post with some marketing text and an actual coupon code. You
   can get valid coupon codes from the OWASP Juice Shop Twitter feed:
   <https://twitter.com/owasp_juiceshop>.

   ![Word Replacer II](/part1/img/word_replacer_ii.png)
3. Enable the plugin and verify your replacements work:

![Coupon Immersion Replacement](/part1/img/coupon_immersion-replacement.png)

![OAuth Immersion Replacement](/part1/img/oauth_immersion-replacement.png)


