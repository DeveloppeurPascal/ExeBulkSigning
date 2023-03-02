# ExeBulkSigning

[Cette page en français.](LISEZMOI.md)

Simple tool to sign all EXE and MSIX files in a folder.

This program is a Delphi FireMonkey project but only useful in Windows environment because it uses a Windows SDK utility.

This code repository contains a project developed in Object Pascal language under Delphi. You don't know what Delphi is and where to download it ? You'll learn more [on this web site](https://delphi-resources.developpeur-pascal.fr/).

## Use case

You can use it to sign your programs before distributing them or to resign them if you signed with an expired certificate without time stamping the signature.

## What you have to do before using the program

To use this program you need the Microsoft Windows SDK on your Windows 10 or 11 computer. Locate signtool.exe on your computer to check if it's installed.

You need a code signing certificate (PFX file and its password). If you don't have any, buy one from an authority like Sectigo, Thawte, Digicert or other authority recognized by Microsoft for Authenticode and Windows Smart Screen system.

You can create a personnal certificate but you need to deploy private key on computers where you will use your signed programs to avoid Windows alerts. For public publishing, you need an official CSC. In the past I used tu buy my CSC on Tucows authors website. Now I buy them to [KSoftware](https://www.ksoftware.net) (less expensive for Sectigo certificates).

Protect your certificate and its password : your reputation is on the line. The security of your users too !

Read more about signtool.exe on [Microsoft documentation](https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/signtool).

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

## Warnings

Signing EXE files is never a problem if the certificate is good.

Signing MSIX files is available only if MSIX is not signed or if it has been signed with the same certificate you are using to resign it.

In case of error, nothing is done, the file doesn't change.
In case of it works, the date/time of the file change. You can display signature informations from file property dialog box.

## Install

To download this project you better should use "git" command but you also can download a ZIP from [its GitHub repository](https://github.com/DeveloppeurPascal/ExeBulkSigning).

**Warning :** if the project has submodules dependencies they wont be in the ZIP file. You'll have to download them manually.

## Dependencies

This project depends on :

* [DeveloppeurPascal/AboutDialog-Delphi-Component](https://github.com/DeveloppeurPascal/AboutDialog-Delphi-Component) have to be in sub folder ./lib-externes/AboutDialog-Delphi-Component
* [DeveloppeurPascal/librairies](https://github.com/DeveloppeurPascal/librairies) have to be in sub folder ./lib-externes/librairies

## How to ask a new feature, report a bug or a security issue ?

If you want an answer from the project owner the best way to ask for a new feature or report a bug is to go to [the GitHub repository](https://github.com/DeveloppeurPascal/ExeBulkSigning) and [open a new issue](https://github.com/DeveloppeurPascal/ExeBulkSigning/issues).

If you found a security issue please don't report it publicly before a patch is available. Explain the case by [sending a private message to the author](https://developpeur-pascal.fr/nous-contacter.php).

You also can fork the repository and contribute by submitting pull requests if you want to help. Please read the [CONTRIBUTING.md](CONTRIBUTING.md) file.

## Dual licensing model

This project is distributed under [AGPL 3.0 or later](https://choosealicense.com/licenses/agpl-3.0/) license.

If you want to use it or a part of it in your projects but don't want to share the sources or don't want to distribute your project under the same license you can buy the right to use it under the [Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/) or a dedicated license ([contact the author](https://developpeur-pascal.fr/nous-contacter.php) to explain your needs).

## Support the project and its author

If you think this project is useful and want to support it, please make a donation to [its author](https://github.com/DeveloppeurPascal). It will help to maintain the code and binaries.

You can use one of those services :

* [GitHub Sponsors](https://github.com/sponsors/DeveloppeurPascal)
* [Liberapay](https://liberapay.com/PatrickPremartin)
* [Patreon](https://www.patreon.com/patrickpremartin)
* [Paypal](https://www.paypal.com/paypalme/patrickpremartin)

or if you speack french you can [subscribe to Zone Abo](https://zone-abo.fr/nos-abonnements.php) on a monthly or yearly basis and get a lot of resources as videos and articles.
