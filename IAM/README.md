# IAM (Web service Identity and Access Managment)
1. In the package.yaml, in the dependencies section add:
- parsec
- bytestring
- random
- servant-server
- wai
- warp
- aeson
- text
- http-conduit

2. Endpoints to query our server
3. ( WITH THE GET METHOD THOSE ARE THE ENDPOINTS TO USE )

- http://localhost:8080/operateurs/ : it's the endpoints to get the list of all the Operators inside the database. 
- http://localhost:8080/operateur/matricule : it's use to get only one operator with a given matricule.
- http://localhost:8080/patients : it's the endpoints to get the list of all the Patients inside the database. 
- http://localhost:8080/patient/code : it's use to get only one Patient with a given code.
- http://localhost:8080/operateur/matricule/roles : it's return the list of roles played by an operator or fail when no roles is affected to him. 
- http://localhost:8080/patient/code/roles : it's return the list of roles played by a patient or fail when no roles is affected to him. 

4. ( WITH THE POST METHOD THOSE ARE THE ENDPOINTS TO USE )

- curl -X POST http://localhost:8080/operateur -H "Content-Type: application/json" -d '{"nomOp2": "nom","prenomOp2": "prenom","matricule2": "RANGER123","email2": {"identifiant2": "nom","domaine2": "wada","extension2": "org"},"passwordOp2": "Ranger$test2001","photo2": "1111111111","statutOp2": "Aucun"}' : It's use to register an operator in our system. and it return success or fail.

- curl -X POST http://localhost:8080/patient -H "Content-Type: application/json" -d '{"nameOf2" : "Nom","firstNameOf2" : "Prenom","emailOf2" : {"identifiant2" : "youremail","domaine2" : "gmail","extension2" : "com" },"photoOf2" : "1000000000","code2" : 2000,"statutP2" : "Aucun"}' : It's use to register a patient in our system.and it return success or fail

- (For connection we use those endpoints)
- curl -X POST http://localhost:8080/operateur/connexion?login=matricule&login=password :  It's use to connect an Operator. and it return connected when it's ok or fail.
- curl -X POST http://localhost:8080/patient/connexion?login=code&login=nom : It's use to connect a Patient.and it return connected when it's ok or fail.

- (For deconnection we use those endpoints)
- curl -X POST http://localhost:8080/operateur/deconnexion -H "Content-Type: application/json" -d '{
"nomOp": "Ranger","prenomOp": "samuel","matricule":"RANGER123","email": {"identifiant":"ranger","domaine": "wada","extension":"org"},"passwordOp": "Ranger$test2001","photo": "1111111111","statutOp": "Connecter"}' : It's use to deconnect an operator and return deconnected in success or fail.

- curl -X POST http://localhost:8080/patient/deconnexion -H "Content-Type: application/json" -d '{"nameOf": "Nkalla","firstNameOf": "Raoul gonzales","emailOf": {"identifiant": "nkalla","domaine": "wada","extension": "org"},"photoOf": "11200012010","code":3277,"statutP": "Connecter"}' : It's use to deconnect a patient and return deconnected in success or fail.

- (To create a new role this is the endPoint)
- curl -X POST http://localhost:8080/role/roleName : the request return us a successful when all things is done.

5. ( WITH THE DELETE METHOD THOSE ARE THE ENDPOINTS TO USE )

- curl -X DELETE http://localhost:8080/operateur/matricule : it's use to delete an operator an return nothing.
- curl -X DELETE http://localhost:8080/patient/code : it's use to delete a patient an return nothing.

6. ( WITH THE PUT METHOD THOSE ARE THE ENDPOINTS TO USE )

- curl -X PUT http://localhost:8080/operateur/ -H "Content-Type: application/json" -d '{
"nomOp": "Ranger","prenomOp": "samuel","matricule":"RANGER123","email": {"identifiant":"ranger","domaine": "wada","extension":"org"},"passwordOp": "Ranger$test2001","photo": "1111111111","statutOp": "Connecter"}' : it's use to update an operator and it return succesful when done or fail.

- curl -X PUT http://localhost:8080/patient/ -H "Content-Type: application/json" -d '{"nameOf": "Nkalla","firstNameOf": "Raoul gonzales","emailOf": {"identifiant": "nkalla","domaine": "wada","extension": "org"},"photoOf": "11200012010","code":3277,"statutP": "Connecter"}' : it's use to update a patient and it return succesful when done or fail.

- curl -X PUT http://localhost:8080/operateur/matricule/role/nomRole : it's use to give a role to an operator.

- curl -X PUT http://localhost:8080/patient/code/role/nomRole : it's use to give a role to a patient.