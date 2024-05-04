# 20240504 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* ajout du nom de fichier (pour son extension) dans le message d'envoi d'un fichier via l'API C/S
* mise à jour des dépendances
* remplacement de l'unité Olf.RTL.FileBuffer local par celui de DeveloppeurPascal/Librairies
* changement de la valeur d'initialisation du champ FileBuffer dans les messages TFileToSignMessage et TSignedFileMessage de l'API C/S
* remplacement du bouton "start" par un bouton "sign locally" et un bouton "sign remotely" dans l'onglet "project"
* ajout des boutons de démarrage et d'arrêt du serveur de signature
* ajout d'un paramètre de lancement automatique du serveur au démarrage du programme et enregistrement avec les autres paramètres du programme
* ajout de la dépendance à "Socket-Messaging-Library" dans les docs
* ajout d'un message TErrorMessage à l'API Client/Server
* préparation de la classe pour le mode client du logiciel dans une unité à part (pour l'utiliser depuis d'autres logiciels)
* préparation de la classe pour le mode serveur du logiciel
* démarrage et arrêt du serveur côté interface utilisateur (reste à traiter les remontées d'erreurs)
* implémentation de la signature des fichiers en mode client opérationnelle sur l'interface utilisateur
* travail sur la classe cliente et la classe serveur, débogage et correction d'anomalies sur l'unité Socket Messaging Library
* finalisation de la librairie cliente pour le mode C/S de Exe Bulk Signing
* ajout de TurboPack/DosCommand dans les dépendances pour prendre en charge le lancement de la signature avec détection de la fin en mode serveur de signature
* modification du module serveur afin d'utliser DosCommnd plutôt que ShellExecute pour signer les programmes reçus
* déploiement de la version 1.3 du 04/05/2024
