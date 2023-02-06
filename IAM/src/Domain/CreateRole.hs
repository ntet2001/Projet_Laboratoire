module Domain.CreateRole where 
import Common.SimpleType 


-- fonction pour creer un nouveau role 

createRole :: NomRole -> Role 
createRole n = MkRole {nameRole = n , roleUserList = []} 