# Exe Bulk Signing

[This page in English.](README.md)

Outil simple pour signer tous les fichiers EXE et MSIX dans un dossier.

Ce programme est un projet Delphi FireMonkey mais n'est utile que dans un environnement Windows car il utilise un utilitaire du SDK Windows.

Ce dépôt de code contient un projet développé en langage Pascal Objet sous Delphi. Vous ne savez pas ce qu'est Dephi ni où le télécharger ? Vous en saurez plus [sur ce site web](https://delphi-resources.developpeur-pascal.fr/).

## Cas d'utilisation

Vous pouvez l'utiliser pour signer vos programmes avant de les distribuer ou pour les resigner si vous avez signé avec un certificat expiré sans horodater la signature.

### Ce que vous devez faire avant d'utiliser le programme

Pour utiliser ce programme, vous avez besoin du Microsoft Windows SDK sur votre ordinateur Windows 10 ou 11. Localisez signtool.exe sur votre ordinateur pour vérifier s'il est installé.

Vous avez besoin d'un certificat de signature de code (fichier PFX et son mot de passe ou token). Si vous n'en avez pas, achetez-en un auprès d'une autorité comme [Sectigo](https://www.sectigo.com/ssl-certificates-tls/code-signing), [Digicert](https://www.digicert.com/software-trust-manager), [Certum](https://www.certum.eu/en/code-signing-certificates/) ou autre autorité reconnue par Microsoft pour Authenticode et le système Windows Smart Screen.

Vous pouvez créer un certificat personnel mais vous devez déployer la clé privée sur les ordinateurs où vous utiliserez vos programmes signés pour éviter les alertes de Windows. Pour la publication publique, vous avez besoin d'un CSC officiel. Dans le passé, j'achetais mes CSC sur le site des auteurs de Tucows puis KSoftware. Maintenant je les achète chez [Certum](https://www.certum.eu/en/code-signing-certificates/) (le moins cher du marché à ma connaissance au 01/02/2024, mais avec un token qui ne fonctionne pas sous Windows ARM pour le moment).

Protégez votre certificat et son mot de passe : votre réputation est en jeu. La sécurité de vos utilisateurs aussi !

Pour en savoir plus sur signtool.exe, consultez la [documentation Microsoft](https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/signtool).

Pour en savoir plus sur les remplacements des fichiers de certificats par des token physiques, consultez [cette explication](https://www.finalbuilder.com/resources/blogs/code-signing-with-usb-tokens).

### Comment utiliser ce programme ?

Lancez le programme.
Remplissez les champs.
Choisissez le dossier dans lequel vous voulez signer les fichiers exe/msix.
Lancez le processus de signature.

Le titre du programme et l'URL sont affichés lorsque Smart Screen indique aux utilisateurs qu'un fichier a été téléchargé. Vous pouvez y mettre quelque chose ou rien. Cela ne fait aucune différence réelle.

### Avertissements

Ne pas (re)signer/distribuer des programmes et des installateurs dont vous n'êtes pas le développeur.

Vérifiez les virus avant de signer les programmes. Ne signez pas un fichier EXE / MSIX s'il contient des virus ou autres malwares. Vous en serez responsable !

### Commande SignTool utilisée

Juste pour dire, le programme fait une simple boucle sur les fichiers dans le dossier choisi et pour chaque fichier sélectionné il exécute cette commande :

"path to signtool.exe" sign /v /debug /f "PFXFilePath" /p PFXPassWord /tr "TimestampServerURLIfSpecified (recommandé)" /td SHA256 /fd SHA256 /d "ProgramTitle (si spécifié)" /du "YourURL (si précisé)" "chemin vers le fichier EXE ou MSIX à signer"

"path to signtool.exe" sign /v /debug /n "UID" /tr "TimestampServerURLIfSpecified (recommandé)" /td SHA256 /fd SHA256 /d "ProgramTitle (si spécifié)" /du "YourURL (si spécifié)" "path to EXE or MSIX file to sign"

"path to signtool.exe" sign /v /debug /n "Certificate name" /tr "TimestampServerURLIfSpecified (recommandé)" /td SHA256 /fd SHA256 /d "ProgramTitle (si spécifié)" /du "YourURL (si spécifié)" "path to EXE or MSIX file to sign"

### Avertissements

La signature de fichiers EXE n'est jamais un problème si le certificat est bon.

La signature des fichiers MSIX n'est possible que si le MSIX n'est pas signé ou s'il a été signé avec le même certificat que celui que vous utilisez pour le resigner.

En cas d'erreur, rien n'est fait, le fichier ne change pas.
En cas de succès, la date et l'heure du fichier sont modifiées. Vous pouvez afficher les informations de signature à partir de la boîte de dialogue des propriétés du fichier.

## Utiliser ce logiciel

Consultez [le site de Exe Bulk Signing](https://exebulksigning.olfsoftware.fr) pour télécharger sa version compilée, en savoir plus sur son fonctionnement, accéder à des vidéos et articles, connaître les différentes versions disponibles et leurs fonctionnalités, contacter le support utilisateurs...

## Présentations et conférences

### Twitch

Suivez mes streams de développement de logiciels, jeux vidéo, applications mobiles et sites web sur [ma chaîne Twitch](https://www.twitch.tv/patrickpremartin) ou en rediffusion sur [Serial Streameur](https://serialstreameur.fr) la plupart du temps en français.

## Installation des codes sources

Pour télécharger ce dépôt de code il est recommandé de passer par "git" mais vous pouvez aussi télécharger un ZIP directement depuis [son dépôt GitHub](https://github.com/DeveloppeurPascal/ExeBulkSigning).

Ce projet utilise des dépendances sous forme de sous modules. Ils seront absents du fichier ZIP. Vous devrez les télécharger à la main.

* [DeveloppeurPascal/AboutDialog-Delphi-Component](https://github.com/DeveloppeurPascal/AboutDialog-Delphi-Component) doit être installé dans le sous dossier ./lib-externes/AboutDialog-Delphi-Component
* [DeveloppeurPascal/Delphi-FMXExtend-Library](https://github.com/DeveloppeurPascal/Delphi-FMXExtend-Library) doit être installé dans le sous dossier ./lib-externes/Delphi-FMXExtend-Library
* [DeveloppeurPascal/librairies](https://github.com/DeveloppeurPascal/librairies) doit être installé dans le sous dossier ./lib-externes/librairies
* [DeveloppeurPascal/Socket-Messaging-Library](https://github.com/DeveloppeurPascal/Socket-Messaging-Library) doit être installé dans le sous dossier ./lib-externes/Socket-Messaging-Library
* [TurboPack/DOSCommand](https://github.com/TurboPack/DOSCommand) doit être installé dans le sous dossier ./lib-externes/DOSCommand

## Documentation et assistance

Je passe par des commentaires au format [XMLDOC](https://docwiki.embarcadero.com/RADStudio/fr/Commentaires_de_documentation_XML) dans Delphi pour documenter mes projets. Ils sont reconnus par Help Insight qui propose de l'aide à la saisie en temps réel dans l'éditeur de code.

J'utilise régulièrement l'outil [DocInsight](https://devjetsoftware.com/products/documentation-insight/) pour les saisir et contrôler leur formatage.

L'export de la documentation est fait en HTML par [DocInsight](https://devjetsoftware.com/products/documentation-insight/) ou [PasDoc](https://pasdoc.github.io) vers le dossier /docs du dépôt. Vous y avez aussi [accès en ligne](https://developpeurpascal.github.io/ExeBulkSigning) grâce à l'hébergement offert par GitHub Pages.

D'autres informations (tutoriels, articles, vidéos, FAQ, présentations et liens) sont disponibles sur [le site web du projet](https://exebulksigning.olfsoftware.fr) ou [le devlog du projet](https://developpeur-pascal.fr/exe-bulk-signing.html).

Si vous avez besoin d'explications ou d'aide pour comprendre ou utiliser certaines parties de ce projet dans le vôtre, n'hésitez pas à [me contacter](https://developpeur-pascal.fr/nous-contacter.php). Je pourrai soit vous orienter vers une ressource en ligne, soit vous proposer une assistance sous forme de prestation payante ou gratuite selon les cas. Vous pouvez aussi me faire signe à l'occasion d'une conférence ou pendant une présentation en ligne.

## Compatibilité

En tant que [MVP Embarcadero](https://www.embarcadero.com/resources/partners/mvp-directory) je bénéficie dès qu'elles sortent des dernières versions de [Delphi](https://www.embarcadero.com/products/delphi) et [C++ Builder](https://www.embarcadero.com/products/cbuilder) dans [RAD Studio](https://www.embarcadero.com/products/rad-studio). C'est donc dans ces versions que je travaille.

Normalement mes librairies et composants doivent aussi fonctionner au moins sur la version en cours de [Delphi Community Edition](https://www.embarcadero.com/products/delphi/starter).

Aucune garantie de compatibilité avec des versions antérieures n'est fournie même si je m'efforce de faire du code propre et ne pas trop utiliser les nouvelles façons d'écrire dedans (type inference, inline var et multilines strings).

Si vous détectez des anomalies sur des versions antérieures n'hésitez pas à [les rapporter](https://github.com/DeveloppeurPascal/ExeBulkSigning/issues) pour que je teste et tente de corriger ou fournir un contournement.

## Licence d'utilisation de ce dépôt de code et de son contenu

Ces codes sources sont distribués sous licence [AGPL 3.0 ou ultérieure](https://choosealicense.com/licenses/agpl-3.0/).

Vous êtes libre d'utiliser le contenu de ce dépôt de code n'importe où à condition :
* d'en faire mention dans vos projets
* de diffuser les modifications apportées aux fichiers fournis dans ce projet sous licence AGPL (en y laissant les mentions de copyright d'origine (auteur, lien vers ce dépôt, licence) obligatoirement complétées par les vôtres)
* de diffuser les codes sources de vos créations sous licence AGPL

Si cette licence ne convient pas à vos besoins (notamment pour un projet commercial) je propose aussi [des licences classiques pour les développeurs et les entreprises](https://exebulksigning.olfsoftware.fr).

Certains éléments inclus dans ce dépôt peuvent dépendre de droits d'utilisation de tiers (images, sons, ...). Ils ne sont pas réutilisables dans vos projets sauf mention contraire.

Les codes sources de ce dépôt de code comme leur éventuelle version compilée sont fournis en l'état sans garantie d'aucune sorte.

## Comment demander une nouvelle fonctionnalité, signaler un bogue ou une faille de sécurité ?

Si vous voulez une réponse du propriétaire de ce dépôt la meilleure façon de procéder pour demander une nouvelle fonctionnalité ou signaler une anomalie est d'aller sur [le dépôt de code sur GitHub](https://github.com/DeveloppeurPascal/ExeBulkSigning) et [d'ouvrir un ticket](https://github.com/DeveloppeurPascal/ExeBulkSigning/issues).

Si vous avez trouvé une faille de sécurité n'en parlez pas en public avant qu'un correctif n'ait été déployé ou soit disponible. [Contactez l'auteur du dépôt en privé](https://developpeur-pascal.fr/nous-contacter.php) pour expliquer votre trouvaille.

Vous pouvez aussi cloner ce dépôt de code et participer à ses évolutions en soumettant vos modifications si vous le désirez. Lisez les explications dans le fichier [CONTRIBUTING.md](CONTRIBUTING.md).

## Soutenez ce projet et son auteur

Si vous trouvez ce dépôt de code utile et voulez le montrer, merci de faire une donation [à son auteur](https://github.com/DeveloppeurPascal). Ca aidera à maintenir ce projet et tous les autres.

Vous pouvez utiliser l'un de ces services :

* [GitHub Sponsors](https://github.com/sponsors/DeveloppeurPascal)
* Ko-fi [en français](https://ko-fi.com/patrick_premartin_fr) ou [en anglais](https://ko-fi.com/patrick_premartin_en)
* [Patreon](https://www.patreon.com/patrickpremartin)
* [Liberapay](https://liberapay.com/PatrickPremartin)

Vous pouvez acheter une licence d'utilisateur pour [mes logiciels](https://lic.olfsoftware.fr/products.php?lng=fr) et [mes jeux vidéo](https://lic.gamolf.fr/products.php?lng=fr) ou [une licence de développeur pour mes bibliothèques](https://lic.developpeur-pascal.fr/products.php?lng=fr) si vous les utilisez dans vos projets.

Je suis également disponible en tant que prestataire pour vous aider à utiliser ce projet ou d'autres, comme pour vos développements de logiciels, applications mobiles et sites Internet. [Contactez-moi](https://vasur.fr/about) pour en discuter.
