# ExeBulkSigning
Simple tool to sign all EXE or MSIX files in a folder.


To use this program you need the Microsoft Windows SDK on your Windows 10 or 11 computer. Locate signtool.exe on your computer to check if it's installed.

You need a code signing certificate (PFX file and its password). If you don't have any, buy one from an authority like Sectigo, Thawte, Digicert or other authority recognized by Microsoft for Authenticode and Windows Smart Screen system.

You can create a personnal certificate but you need to deploy private key on computers where you will use your signed programs to avoid Windows alerts. For public publishing, you need an official CSC. In the past I used tu buy my CSC on Tucows authors website. Now I buy them to [KSoftware](https://www.ksoftware.net) (less expensive for Sectigo certificates).

Read more about signtool.exe on [Microsoft documentation](https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/signtool).

-----

Launch the program.
Fill the fields.
Choose the folder from which exe/msix files you want to sign.
Start signing process.

-----

Don't (re)sign programs and installers you are not the developer.
Don't distribute files signed with your certificate if you are not allowed to do it.

And of course protect your certificate and its password : your reputation is on the line. The security of your users too !

-----

Just to say, the program does a simple loop on files in the choosen folder and for each selected file it executes this command :

"path to signtool.exe" sign /v /debug /f "PFXFilePath" /p PFXPassWord /tr "TimestampServerURLIfSpecified (recommanded)" /td SHA256 /fd SHA256 /d "ProgramTitle (if specified)" /du "YourURL (if specified)" "path to EXE or MSIX file to sign"
