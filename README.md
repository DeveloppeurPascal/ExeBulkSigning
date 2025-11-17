# Exe Bulk Signing

[Cette page en français.](LISEZMOI.md)

> [!WARNING]
> Following Microsoft's decision to merge GitHub into its AI division in the summer of 2025 and therefore to consider what we publish on it only as a source of training for its models without any compensation (apart from hosting the source codes) or to bombard us with their injunctions to use Copilot everywhere, for everything and anything, I have decided to stop maintaining the repositories here.
>
> Maintenance of this project has been moved to Codeberg at https://codeberg.org/PatrickPremartin/ExeBulkSigning
>
> Codeberg is a community-based hosting service located in Europe that respects developers, the license of each project, and the privacy of those who connect to it.

> [!NOTE]
> To open or work on a ticket for this project, go to https://codeberg.org/PatrickPremartin/ExeBulkSigning/issues
> To make a PULL REQUEST on this project, go to https://codeberg.org/PatrickPremartin/ExeBulkSigning/pulls
> For any other information or to contact me, you can also visit the project website at https://exebulksigning.olfsoftware.fr or its devlog at https://exebulksigning.olfsoftware.fr/dev-corner.html.
> This code repository will be archived once the migration is complete and will no longer be updated on GitHub.

Simple tool to sign all EXE and MSIX files in a folder.

This program is a Delphi FireMonkey project but only useful in Windows environment because it uses a Windows SDK utility.

This code repository contains a project developed in Object Pascal language under Delphi. You don't know what Delphi is and where to download it ? You'll learn more [on this web site](https://delphi-resources.developpeur-pascal.fr/).

## Use case

You can use it to sign your programs before distributing them or to resign them if you signed with an expired certificate without time stamping the signature.

### What you have to do before using the program

To use this program you need the Microsoft Windows SDK on your Windows 10 or 11 computer. Locate signtool.exe on your computer to check if it's installed.

You need a code signing certificate (PFX file and its password or a token). If you don't have any, buy one from an authority like [Sectigo](https://www.sectigo.com/ssl-certificates-tls/code-signing), [Digicert](https://www.digicert.com/software-trust-manager), [Certum](https://www.certum.eu/en/code-signing-certificates/) or other authority recognized by Microsoft for Authenticode and Windows Smart Screen system.

You can create a personnal certificate but you need to deploy private key on computers where you will use your signed programs to avoid Windows alerts. For public publishing, you need an official CSC. In the past I used tu buy my CSC on Tucows authors website and after KSoftware. Now I buy them to [Certum](https://www.certum.eu/en/code-signing-certificates/) (the cheapest on the market as far as I know on 2024-02-01, but with a token that doesn't currently work on Windows ARM).

Protect your certificate and its password : your reputation is on the line. The security of your users too !

Read more about signtool.exe on [Microsoft documentation](https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/signtool).

To find out more about replacing certificate files with physical tokens, see [this explanation](https://www.finalbuilder.com/resources/blogs/code-signing-with-usb-tokens).

### How to use this program ?

Launch the program.
Fill the fields.
Choose the folder from which exe/msix files you want to sign.
Start signing process.

Program title and URL are displayed when Smart Screen tells users a file have been downloaded. You can put something in it or nothing. It does no real difference.

### Warnings

Don't (re)sign/distribute programs and installers you are not the developer.

Check viruses before signing programs. Don't sign an exe / MSIX file if it contains viruses or other malware. You will be responsible of it !

### SignTool command used

Just to say, the program does a simple loop on files in the choosen folder and for each selected file it executes this command :

"path to signtool.exe" sign /v /debug /f "PFXFilePath" /p PFXPassWord /tr "TimestampServerURLIfSpecified (recommanded)" /td SHA256 /fd SHA256 /d "ProgramTitle (if specified)" /du "YourURL (if specified)" "path to EXE or MSIX file to sign"

"path to signtool.exe" sign /v /debug /n "UID" /tr "TimestampServerURLIfSpecified (recommanded)" /td SHA256 /fd SHA256 /d "ProgramTitle (if specified)" /du "YourURL (if specified)" "path to EXE or MSIX file to sign"

"path to signtool.exe" sign /v /debug /n "Certificate name" /tr "TimestampServerURLIfSpecified (recommanded)" /td SHA256 /fd SHA256 /d "ProgramTitle (if specified)" /du "YourURL (if specified)" "path to EXE or MSIX file to sign"

### Warnings

Signing EXE files is never a problem if the certificate is good.

Signing MSIX files is available only if MSIX is not signed or if it has been signed with the same certificate you are using to resign it.

In case of error, nothing is done, the file doesn't change.
In case of it works, the date/time of the file change. You can display signature informations from file property dialog box.

## Using this software

Visit [the Exe Bulk Signing website](https://exebulksigning.olfsoftware.fr) to download the compiled version, learn more about how it works, access videos and articles, find out about the different versions available and their features, contact user support...

## Talks and conferences

### Twitch

Follow my development streams of software, video games, mobile applications and websites on [my Twitch channel](https://www.twitch.tv/patrickpremartin) or as replays on [Serial Streameur](https://serialstreameur.fr) mostly in French.

## Source code installation

To download this code repository, we recommend using "git", but you can also download a ZIP file directly from [its GitHub repository](https://github.com/DeveloppeurPascal/ExeBulkSigning).

This project uses dependencies in the form of sub-modules. They will be absent from the ZIP file. You'll have to download them by hand.

* [DeveloppeurPascal/AboutDialog-Delphi-Component](https://github.com/DeveloppeurPascal/AboutDialog-Delphi-Component) must be installed in the ./lib-externes/AboutDialog-Delphi-Component subfolder.
* [DeveloppeurPascal/Delphi-FMXExtend-Library](https://github.com/DeveloppeurPascal/Delphi-FMXExtend-Library) must be installed in the ./lib-externes/Delphi-FMXExtend-Library subfolder.
* [DeveloppeurPascal/librairies](https://github.com/DeveloppeurPascal/librairies) must be installed in the ./lib-externes/librairies subfolder.
* [DeveloppeurPascal/Socket-Messaging-Library](https://github.com/DeveloppeurPascal/Socket-Messaging-Library) must be installed in the ./lib-externes/Socket-Messaging-Library subfolder.
* [TurboPack/DOSCommand](https://github.com/TurboPack/DOSCommand) must be installed in the ./lib-externes/DOSCommand subfolder.

## Documentation and support

I use comments in [XMLDOC](https://docwiki.embarcadero.com/RADStudio/en/XML_Documentation_Comments) format in Delphi to document my projects. They are recognized by Help Insight, which offers real-time input help in the code editor.

I regularly use the [DocInsight](https://devjetsoftware.com/products/documentation-insight/) tool to enter them and check their formatting.

Documentation is exported in HTML by [DocInsight](https://devjetsoftware.com/products/documentation-insight/) or [PasDoc](https://pasdoc.github.io) to the /docs folder of the repository. You can also [access it online](https://developpeurpascal.github.io/ExeBulkSigning) through the hosting offered by GitHub Pages.

Further information (tutorials, articles, videos, FAQ, talks and links) can be found on [the project website](https://exebulksigning.olfsoftware.fr) or [the project devlog](https://developpeur-pascal.fr/exe-bulk-signing.html).

If you need explanations or help in understanding or using parts of this project in yours, please [contact me](https://developpeur-pascal.fr/nous-contacter.php). I can either direct you to an online resource, or offer you assistance in the form of a paid or free service, depending on the case. You can also contact me at a conference or during an online presentation.

## Compatibility

As an [Embarcadero MVP](https://www.embarcadero.com/resources/partners/mvp-directory), I benefit from the latest versions of [Delphi](https://www.embarcadero.com/products/delphi) and [C++ Builder](https://www.embarcadero.com/products/cbuilder) in [RAD Studio](https://www.embarcadero.com/products/rad-studio) as soon as they are released. I therefore work with these versions.

Normally, my libraries and components should also run on at least the current version of [Delphi Community Edition](https://www.embarcadero.com/products/delphi/starter).

There's no guarantee of compatibility with earlier versions, even though I try to keep my code clean and avoid using too many of the new ways of writing in it (type inference, inline var and multiline strings).

If you detect any anomalies on earlier versions, please don't hesitate to [report them](https://github.com/DeveloppeurPascal/ExeBulkSigning/issues) so that I can test and try to correct or provide a workaround.

## License to use this code repository and its contents

This source code is distributed under the [AGPL 3.0 or later](https://choosealicense.com/licenses/agpl-3.0/) license.

You are free to use the contents of this code repository anywhere provided :
* you mention it in your projects
* distribute the modifications made to the files provided in this AGPL-licensed project (leaving the original copyright notices (author, link to this repository, license) must be supplemented by your own)
* to distribute the source code of your creations under the AGPL license.

If this license doesn't suit your needs (especially for a commercial project) I also offer [classic licenses for developers and companies](https://exebulksigning.olfsoftware.fr).

Some elements included in this repository may depend on third-party usage rights (images, sounds, etc.). They are not reusable in your projects unless otherwise stated.

The source codes of this code repository as well as any compiled version are provided “as is” without warranty of any kind.

## How to ask a new feature, report a bug or a security issue ?

If you want an answer from the project owner the best way to ask for a new feature or report a bug is to go to [the GitHub repository](https://github.com/DeveloppeurPascal/ExeBulkSigning) and [open a new issue](https://github.com/DeveloppeurPascal/ExeBulkSigning/issues).

If you found a security issue please don't report it publicly before a patch is available. Explain the case by [sending a private message to the author](https://developpeur-pascal.fr/nous-contacter.php).

You also can fork the repository and contribute by submitting pull requests if you want to help. Please read the [CONTRIBUTING.md](CONTRIBUTING.md) file.

## Support the project and its author

If you think this project is useful and want to support it, please make a donation to [its author](https://github.com/DeveloppeurPascal). It will help to maintain this project and all others.

You can use one of those services :

* [GitHub Sponsors](https://github.com/sponsors/DeveloppeurPascal)
* Ko-fi [in French](https://ko-fi.com/patrick_premartin_fr) or [in English](https://ko-fi.com/patrick_premartin_en)
* [Patreon](https://www.patreon.com/patrickpremartin)
* [Liberapay](https://liberapay.com/PatrickPremartin)

You can buy an end user license for [my softwares](https://lic.olfsoftware.fr/products.php?lng=en) and [my video games](https://lic.gamolf.fr/products.php?lng=en) or [a developer license for my libraries](https://lic.developpeur-pascal.fr/products.php?lng=en) if you use them in your projects.

I'm also available as a service provider to help you use this or other projects, such as software development, mobile applications and websites. [Contact me](https://vasur.fr/about) to discuss.
