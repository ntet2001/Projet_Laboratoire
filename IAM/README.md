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
-   ( WITH THE GET METHOD THOSE ARE THE ENDPOINTS TO USE )

- http://localhost:8080/operateurs/ : it's the endpoints to get the list of all the Operators inside the database. 
- http://localhost:8080/operateur/matricule : it's use to get only one operator with a given matricule.
- http://localhost:8080/patients : it's the endpoints to get the list of all the Patients inside the database. 
- http://localhost:8080/patient/code : it's use to get only one Patient with a given code.

-   ( WITH THE POST METHOD THOSE ARE THE ENDPOINTS TO USE )

- http://localhost:8080/operateur/ :  curl -X POST http://localhost:8080/operateur -H "Content-Type: application/json" -d '{"nomOp2": "Ranger","prenomOp2": "samuel","matricule2": "RANGER123","email2": {"identifiant2": "ranger","domaine2": "wada","extension2": "org"},"passwordOp2": "Ranger$test2001","photo2": "1111111111","statutOp2": "Aucun"}' 

