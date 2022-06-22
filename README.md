# ExeBulkSigning
Simple tool to sign all EXE and MSIX files in a folder.

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
