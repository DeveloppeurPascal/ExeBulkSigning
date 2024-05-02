# 20240502 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour des dépendances
* ajout du projet [FMX Extend](https://github.com/DeveloppeurPascal/Delphi-FMXExtend-Library) en sous-module
* mise à jour des docs FR/EN (dépendances)
* mise en place du sélecteur de dossier sur le choix du dossier à scanner pour trouver les fichiers à signer
* mise à jour de l'initialisation du chemin vers le fichier de paramètres en passant par le module "v2" de l'unité Olf.RTL.Params.pas plutôt que le mettre en dur dans le projet
* mise en place du chiffrement des paramètres du programme (en RELEASE) avec prise en compte des paramètres non chiffrés s'ils existaient déjà
* ajout d'un paramètre "autres options" en saisie au niveau du SDK Microsoft pour permettre de mettre ce qu'on veut sur SignTool sans avoir à le faire en dur dans le programme (notamment la prise en charge de signature en ligne)
* retrait du bouton "close" de l'onglet "projet"
* ajout de boutons SAVE & CANCEL sur l'onglet "Certificate" pour enregistrer ou annuler juste les champs de saisie de cet onglet
* ajout de boutons SAVE & CANCEL sur l'onglet "Microsoft SDK" pour enregistrer ou annuler juste les champs de saisie de cet onglet

* ajout de Socket Messaging Library comme sous-module
* définition des messages de l'API client/serveur de signature de fichiers via ExeBulkSigning
* création de la classe TOlfFileBuffer dans l'unité Olf.RTL.FileBuffer
* ajout d'un onglet "Client/Server mode" et des éléments nécessaires à la gestion du client/serveur et de la signature de fichiers à distances

* modification du numéro de version vers 1.3 du 02/05/2024 dans la fiche principale (à déployer après implémentation et tests du client/server)
