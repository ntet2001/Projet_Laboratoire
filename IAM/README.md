# IAM (Web service Identity and Access Managment)

This module is build to control who have access to what. It's here that we Identify users and give them different access to our application. 

## In the package.yaml, in the dependencies section add:
- parsec
- bytestring
- random
- servant-server
- wai
- warp
- aeson
- text
- http-conduit

## Here are the Endpoints to query our server

1. (WITH THE **GET METHOD** THOSE ARE THE ENDPOINTS TO USE )

- **http://localhost:8080/operateurs/** : it's the endpoints to get the list of all the Operators in the database.

- **http://localhost:8080/operateurs/matricule** : it's use to get only one operator with a given ***matricule***.

- **http://localhost:8080/patients** : it's the endpoints to get the list of all the Patients inside the database. 

- **http://localhost:8080/patients/name** : it's use to get only one Patient with a given ***name***.

- **http://localhost:8080/operateurs/matricule/roles** : it's return the list of roles played by an operator or fail when no roles is affected to him. 

- **http://localhost:8080/patients/name/roles** : it's return the list of roles played by a patient or fail when no roles is affected to him. 

- **http://localhost:8080/role/all roles/** : it return the list of roles.

2. ( WITH THE **POST METHOD** THOSE ARE THE ENDPOINTS TO USE )

- **http://localhost:8080/operateurs** : Here we take an Operator in this json format ***{"nomOp2": "Ntet","prenomOp2": "Igor","matricule2": "WADA001","email2": {"identifiant2": "manyamaigor2001","domaine2": "gmail","extension2": "com"},"passwordOp2": "Wada$igor001","photo2": "000000000000","statutOp2": "Aucun"}*** , it's use to register an operator in our system and it return successful or fail. 
**NB** : the password shall respect a (Capital Letter | special character | number ).

- **http://localhost:8080/patients** : Here we take a patient in this json format ***{"nameOf2" : "Noumedem","firstNameOf2" : "borice","emailOf2" : {"identifiant2" : "boricenoumedem4","domaine2" : "gmail","extension2" : "com" },"photoOf2" : "000000000000","statutP2" : "Aucun"}*** , It's use to register a patient in our system and it return successful or fail

- ***(For connection we use those endpoints)***

- **http://localhost:8080/operateurs/connexion?login=WADA001&login=Wada$igor001** :  It's use to connect an Operator. and it return ***connected*** when it's ok or ***fail***.

- **http://localhost:8080/patients/connexion?login=code&login=Noumedemborice** : It's use to connect a Patient and it return ***connected*** when it's ok or ***fail***.

- ***(For deconnection we use those endpoints)***

- **http://localhost:8080/operateurs/deconnexion?login=WADA001&login=Wada$igor001** : It's use to deconnect an operator and return ***deconnected*** in success or ***fail***.

- **http://localhost:8080/patients/deconnexion?login=code&login=Noumedemborice** : It's use to deconnect a patient and return ***deconnected*** in success or ***fail***.

- ***(To create a new role this is the endPoint)***

- **http://localhost:8080/role/Administrateur** : the request return us a ***successful*** when all things is done.

3. ( WITH THE **DELETE METHOD** THOSE ARE THE ENDPOINTS TO USE )

- **http://localhost:8080/operateurs/WADA001** : it's use to delete an operator an return nothing.
- **http://localhost:8080/patients/Noumedemborice** : it's use to delete a patient an return nothing.

4. ( WITH THE **PUT METHOD** THOSE ARE THE ENDPOINTS TO USE )

- **http://localhost:8080/operateurs** : we take this json format ***{"nom" : "Ntet","prenom" : "Manyama","matricul" : "WADA001","mail" : {"identifiant": "manyamaigor2001","domaine": "gmail","extension": "com"},"image" : "100000000000","statut" : "Aucun"}*** : it's use to update an operator and it return ***Updated successfuly*** when done or ***fail***.

- **http://localhost:8080/patients** : we take this json format ***{"nomPatient" : "Noumedem borice", "newParams" : {"nom" : "Neudjieu","prenom" : "Raoul" ,"mail" : " elieraoulnet@gmail.com"}}*** it's use to update a patient and it return ***succesful*** when done or ***fail***.

- **http://localhost:8080/operateurs/WADA001/role/Administrateur** : it's use to give a role to an operator.

- **http://localhost:8080/patients/Neudjieu Raoul/role/Patient** : it's use to give a role to a patient.

- **http://localhost:8080/operateurs/password** : we take this format ***{"matriculepass" : "WADA001","oldPassword" : "Wada$igor001","newPassword" : "Wada@igor001"}*** it's use to update an operator password and it return ***Updated Password successful*** when done or ***fail***. 