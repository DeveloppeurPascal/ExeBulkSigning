# ExeBulkSigning

[This page in english.](README.md)

Outil simple pour signer tous les fichiers EXE et MSIX dans un dossier.

Ce programme est un projet Delphi FireMonkey mais n'est utile que dans un environnement Windows car il utilise un utilitaire du SDK Windows.

Ce dépôt de code contient un projet développé en langage Pascal Objet sous Delphi. Vous ne savez pas ce qu'est Dephi ni où le télécharger ? Vous en saurez plus [sur ce site web](https://delphi-resources.developpeur-pascal.fr/).

## Cas d'utilisation

Vous pouvez l'utiliser pour signer vos programmes avant de les distribuer ou pour les resigner si vous avez signé avec un certificat expiré sans horodater la signature.

## Ce que vous devez faire avant d'utiliser le programme

Pour utiliser ce programme, vous avez besoin du Microsoft Windows SDK sur votre ordinateur Windows 10 ou 11. Localisez signtool.exe sur votre ordinateur pour vérifier s'il est installé.

Vous avez besoin d'un certificat de signature de code (fichier PFX et son mot de passe). Si vous n'en avez pas, achetez-en un auprès d'une autorité comme Sectigo, Thawte, Digicert ou autre autorité reconnue par Microsoft pour Authenticode et le système Windows Smart Screen.

Vous pouvez créer un certificat personnel mais vous devez déployer la clé privée sur les ordinateurs où vous utiliserez vos programmes signés pour éviter les alertes de Windows. Pour la publication publique, vous avez besoin d'un CSC officiel. Dans le passé, j'achetais mes CSC sur le site des auteurs de Tucows. Maintenant je les achète chez [KSoftware](https://www.ksoftware.net) (moins cher pour les certificats Sectigo).

Protégez votre certificat et son mot de passe : votre réputation est en jeu. La sécurité de vos utilisateurs aussi !

Pour en savoir plus sur signtool.exe, consultez la [documentation Microsoft](https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/signtool).

## Comment utiliser ce programme ?

Lancez le programme.
Remplissez les champs.
Choisissez le dossier dans lequel vous voulez signer les fichiers exe/msix.
Lancez le processus de signature.

Le titre du programme et l'URL sont affichés lorsque Smart Screen indique aux utilisateurs qu'un fichier a été téléchargé. Vous pouvez y mettre quelque chose ou rien. Cela ne fait aucune différence réelle.

## Avertissements

Ne pas (re)signer/distribuer des programmes et des installateurs dont vous n'êtes pas le développeur.

Vérifiez les virus avant de signer les programmes. Ne signez pas un fichier EXE / MSIX s'il contient des virus ou autres malwares. Vous en serez responsable !

## Commande SignTool utilisée

Juste pour dire, le programme fait une simple boucle sur les fichiers dans le dossier choisi et pour chaque fichier sélectionné il exécute cette commande :

"path to signtool.exe" sign /v /debug /f "PFXFilePath" /p PFXPassWord /tr "TimestampServerURLIfSpecified (recommanded)" /td SHA256 /fd SHA256 /d "ProgramTitle (si spécifié)" /du "YourURL (si précisé)" "chemin vers le fichier EXE ou MSIX à signer"

## Avertissements

La signature de fichiers EXE n'est jamais un problème si le certificat est bon.

La signature des fichiers MSIX n'est possible que si le MSIX n'est pas signé ou s'il a été signé avec le même certificat que celui que vous utilisez pour le resigner.

En cas d'erreur, rien n'est fait, le fichier ne change pas.
En cas de succès, la date et l'heure du fichier sont modifiées. Vous pouvez afficher les informations de signature à partir de la boîte de dialogue des propriétés du fichier.

## Installation

Pour télécharger ce projet il est recommandé de passer par "git" mais vous pouvez aussi télécharger un ZIP directement depuis [son dépôt GitHub](https://github.com/DeveloppeurPascal/ExeBulkSigning).

**Attention :** si le projet utilise des dépendances sous forme de sous modules ils seront absents du fichier ZIP. Vous devrez les télécharger à la main.

## Dépendances

Ce dépôt de code dépend des dépôts suivants :

* [DeveloppeurPascal/AboutDialog-Delphi-Component](https://github.com/DeveloppeurPascal/AboutDialog-Delphi-Component) doit se trouver dans le sous-dossier ./lib-externes/AboutDialog-Delphi-Component
* [DeveloppeurPascal/librairies](https://github.com/DeveloppeurPascal/librairies) doit se trouver dans le sous-dossier ./lib-externes/librairies

## Comment demander une nouvelle fonctionnalité, signaler un bogue ou une faille de sécurité ?

Si vous voulez une réponse du propriétaire de ce dépôt la meilleure façon de procéder pour demander une nouvelle fonctionnalité ou signaler une anomalie est d'aller sur [le dépôt de code sur GitHub](https://github.com/DeveloppeurPascal/ExeBulkSigning) et [d'ouvrir un ticket](https://github.com/DeveloppeurPascal/ExeBulkSigning/issues).

Si vous avez trouvé une faille de sécurité n'en parlez pas en public avant qu'un correctif n'ait été déployé ou soit disponible. [Contactez l'auteur du dépôt en privé](https://developpeur-pascal.fr/nous-contacter.php) pour expliquer votre trouvaille.

Vous pouvez aussi cloner ce dépôt de code et participer à ses évolutions en soumettant vos modifications si vous le désirez. Lisez les explications dans le fichier [CONTRIBUTING.md](CONTRIBUTING.md).

## Modèle de licence double

Ce projet est distribué sous licence [AGPL 3.0 ou ultérieure] (https://choosealicense.com/licenses/agpl-3.0/).

Si vous voulez l'utiliser en totalité ou en partie dans vos projets mais ne voulez pas en partager les sources ou ne voulez pas distribuer votre projet sous la même licence, vous pouvez acheter le droit de l'utiliser sous la licence [Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/) ou une licence dédiée ([contactez l'auteur](https://developpeur-pascal.fr/nous-contacter.php) pour discuter de vos besoins).

## Supportez ce projet et son auteur

Si vous trouvez ce dépôt de code utile et voulez le montrer, merci de faire une donation [à son auteur](https://github.com/DeveloppeurPascal). Ca aidera à maintenir le projet (codes sources et binaires).

Vous pouvez utiliser l'un de ces services :

* [GitHub Sponsors](https://github.com/sponsors/DeveloppeurPascal)
* [Liberapay](https://liberapay.com/PatrickPremartin)
* [Patreon](https://www.patreon.com/patrickpremartin)
* [Paypal](https://www.paypal.com/paypalme/patrickpremartin)

ou si vous parlez français vous pouvez [vous abonner à Zone Abo](https://zone-abo.fr/nos-abonnements.php) sur une base mensuelle ou annuelle et avoir en plus accès à de nombreuses ressources en ligne (vidéos et articles).
