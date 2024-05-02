# Exe Bulk Signing

[Cette page en français.](LISEZMOI.md)

Simple tool to sign all EXE and MSIX files in a folder.

This program is a Delphi FireMonkey project but only useful in Windows environment because it uses a Windows SDK utility.

This code repository contains a project developed in Object Pascal language under Delphi. You don't know what Delphi is and where to download it ? You'll learn more [on this web site](https://delphi-resources.developpeur-pascal.fr/).

## Use case

You can use it to sign your programs before distributing them or to resign them if you signed with an expired certificate without time stamping the signature.

## What you have to do before using the program

To use this program you need the Microsoft Windows SDK on your Windows 10 or 11 computer. Locate signtool.exe on your computer to check if it's installed.

You need a code signing certificate (PFX file and its password or a token). If you don't have any, buy one from an authority like [Sectigo](https://www.sectigo.com/ssl-certificates-tls/code-signing), [Digicert](https://www.digicert.com/software-trust-manager), [Certum](https://www.certum.eu/en/code-signing-certificates/) or other authority recognized by Microsoft for Authenticode and Windows Smart Screen system.

You can create a personnal certificate but you need to deploy private key on computers where you will use your signed programs to avoid Windows alerts. For public publishing, you need an official CSC. In the past I used tu buy my CSC on Tucows authors website and after KSoftware. Now I buy them to [Certum](https://www.certum.eu/en/code-signing-certificates/) (the cheapest on the market as far as I know on 2024-02-01, but with a token that doesn't currently work on Windows ARM).

Protect your certificate and its password : your reputation is on the line. The security of your users too !

Read more about signtool.exe on [Microsoft documentation](https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/signtool).

To find out more about replacing certificate files with physical tokens, see [this explanation](https://www.finalbuilder.com/resources/blogs/code-signing-with-usb-tokens).

## How to use this program ?

Launch the program.
Fill the fields.
Choose the folder from which exe/msix files you want to sign.
Start signing process.

Program title and URL are displayed when Smart Screen tells users a file have been downloaded. You can put something in it or nothing. It does no real difference.

## Warnings

Don't (re)sign/distribute programs and installers you are not the developer.

Check viruses before signing programs. Don't sign an exe / MSIX file if it contains viruses or other malware. You will be responsible of it !

## SignTool command used

Just to say, the program does a simple loop on files in the choosen folder and for each selected file it executes this command :

"path to signtool.exe" sign /v /debug /f "PFXFilePath" /p PFXPassWord /tr "TimestampServerURLIfSpecified (recommanded)" /td SHA256 /fd SHA256 /d "ProgramTitle (if specified)" /du "YourURL (if specified)" "path to EXE or MSIX file to sign"

"path to signtool.exe" sign /v /debug /n "UID" /tr "TimestampServerURLIfSpecified (recommanded)" /td SHA256 /fd SHA256 /d "ProgramTitle (if specified)" /du "YourURL (if specified)" "path to EXE or MSIX file to sign"

"path to signtool.exe" sign /v /debug /n "Certificate name" /tr "TimestampServerURLIfSpecified (recommanded)" /td SHA256 /fd SHA256 /d "ProgramTitle (if specified)" /du "YourURL (if specified)" "path to EXE or MSIX file to sign"

## Warnings

Signing EXE files is never a problem if the certificate is good.

Signing MSIX files is available only if MSIX is not signed or if it has been signed with the same certificate you are using to resign it.

In case of error, nothing is done, the file doesn't change.
In case of it works, the date/time of the file change. You can display signature informations from file property dialog box.

## Using this software

This software is available in a directly installable or executable production version. It is distributed as shareware.

You can download and redistribute it free of charge, provided you do not modify its content (installer, program, additional files, etc.).

[Download program or installer](https://olfsoftware.lemonsqueezy.com/checkout/buy/84b7ba9b-5c2f-48bb-b53f-c59faed560cf)

If you use this software regularly and are satisfied with it, you are invited to purchase an end-user license. Purchasing a license will give you access to software updates, as well as enabling optional features.

[Buy a license](https://olfsoftware.lemonsqueezy.com/checkout/buy/8a5006e1-aebd-41ed-a531-0102fad08cd8)

You can also [visit the software website](https://exebulksigning.olfsoftware.fr/) to find out more about how it works, access videos and articles, find out about the different versions available and their features, contact user support...

## Source code installation

To download this code repository, we recommend using "git", but you can also download a ZIP file directly from [its GitHub repository](https://github.com/DeveloppeurPascal/ExeBulkSigning).

This project uses dependencies in the form of sub-modules. They will be absent from the ZIP file. You'll have to download them by hand.

* [DeveloppeurPascal/AboutDialog-Delphi-Component](https://github.com/DeveloppeurPascal/AboutDialog-Delphi-Component) must be installed in the ./lib-externes/AboutDialog-Delphi-Component subfolder.
* [DeveloppeurPascal/Delphi-FMXExtend-Library](https://github.com/DeveloppeurPascal/Delphi-FMXExtend-Library) must be installed in the ./lib-externes/Delphi-FMXExtend-Library subfolder.
* [DeveloppeurPascal/librairies](https://github.com/DeveloppeurPascal/librairies) must be installed in the ./lib-externes/librairies subfolder.

## License to use this code repository and its contents

This source code is distributed under the [AGPL 3.0 or later license](https://choosealicense.com/licenses/agpl-3.0/).

You are generally free to use the contents of this code repository anywhere, provided that:
* you mention it in your projects
* distribute the modifications made to the files supplied in this project under the AGPL license (leaving the original copyright notices (author, link to this repository, license) which must be supplemented by your own)
* to distribute the source code of your creations under the AGPL license.

If this license doesn't suit your needs, you can purchase the right to use this project under the [Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/) or a dedicated commercial license ([contact the author](https://developpeur-pascal.fr/nous-contacter.php) to explain your needs).

These source codes are provided as is, without warranty of any kind.

Certain elements included in this repository may be subject to third-party usage rights (images, sounds, etc.). They are not reusable in your projects unless otherwise stated.

## How to ask a new feature, report a bug or a security issue ?

If you want an answer from the project owner the best way to ask for a new feature or report a bug is to go to [the GitHub repository](https://github.com/DeveloppeurPascal/ExeBulkSigning) and [open a new issue](https://github.com/DeveloppeurPascal/ExeBulkSigning/issues).

If you found a security issue please don't report it publicly before a patch is available. Explain the case by [sending a private message to the author](https://developpeur-pascal.fr/nous-contacter.php).

You also can fork the repository and contribute by submitting pull requests if you want to help. Please read the [CONTRIBUTING.md](CONTRIBUTING.md) file.

## Support the project and its author

If you think this project is useful and want to support it, please make a donation to [its author](https://github.com/DeveloppeurPascal). It will help to maintain the code and binaries.

You can use one of those services :

* [GitHub Sponsors](https://github.com/sponsors/DeveloppeurPascal)
* [Liberapay](https://liberapay.com/PatrickPremartin)
* [Patreon](https://www.patreon.com/patrickpremartin)
* [Paypal](https://www.paypal.com/paypalme/patrickpremartin)

or if you speack french you can [subscribe to Zone Abo](https://zone-abo.fr/nos-abonnements.php) on a monthly or yearly basis and get a lot of resources as videos and articles.
