
	Objectifs
Créer un système de rapport de laboratoire médical, qui pourra être utilisé pour publier les rapports des résultats de tests aux patients.
Spécifications fonctionnelles
Créer une application web de gestion des rapports des laboratoires médicaux où les rapports des résultats des tests médicaux pourraient être publiés aux patients.
L’application possèdera plusieurs types d'utilisateurs: Les opérateurs, les patients. 

	Opérateurs
	
Un utilisateur opérateur (exerçant dans un laboratoire d’analyse médical) doit être en mesure de se connecter à l’application en fournissant ses identifiants (nom d’utilisateur et mot de passe) et exécutez les tâche privilégiées suivantes (les patients n’ont pas accès à ces fonctionnalités):
CRUD (Create, Read, Update, Delete) des rapports (Plusieurs tests et résultats dans un rapport)
CRUD des patients (incluant le code d'accès)
Le laboratoire doit envoyer (par e-mail) un message texte au patient contenant le code d'accès pour se connecter au système et voir les résultats des tests. 
	
	Patients
	
L’utilisateur patient peut se connecter à l’application en utilisant son nom (dans un champ autocomplete) et son code d'accès qui lui a été envoyé ; et peut effectuer les opérations suivantes:
Afficher la liste de ses rapports;
Afficher les détails d’un rapport sur une page (nombre de tests positifs, nombre de tests négatifs, nombre de tests en attente de résultat, etc.)
Exporter le rapport sous le format PDF
Envoyer le rapport par email (joindre le fichier PDF)


# Projet_Laboratoire
## Module IAM (Identity Access Management) Added  
## Module EFA (Enregistrement Fiche Analyse) Added 
## Module Notification added
## Module Rapport added
