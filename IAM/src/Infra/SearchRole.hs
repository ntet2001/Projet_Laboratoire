module Infra.SearchRole where 


import Common.SimpleType 
import Infra.HelperRole

-- fonction qui ressort la liste de tous les role joués par un utilisateur 

searchRole :: User Operateur Patient -> String -> IO [NomRole]
searchRole (Operateur x) file = do 
     opSearchRoleHelper x file
searchRole (Patient y) file = do 
    paSearchRoleHelper y file