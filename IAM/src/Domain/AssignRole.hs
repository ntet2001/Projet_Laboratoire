{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
module Domain.AssignRole where 

import Common.SimpleType
import Infra.HelperRole


-- fonction qui assigne un role a un utilisateur connecté

asignRole :: NomRole -> User Operateur Patient -> IO (Either String Role)
asignRole someName  (Operateur op) = do  
    checkRole <- matchRole someName "roles.txt"
    case checkRole of 
        fail -> return $ Left "ce nom ne correspond à un aucun role"
        theRole -> 
            if statutOp op == Connecter 
                then return $ Right $ opRole checkRole (matricule op) 
            else  return $ Left "cet utilisateur n'est pas connecté"
asignRole someName (Patient pa ) = do 
    checkRole <- matchRole someName "roles.txt"
    case checkRole of 
        fail -> return $ Left "ce nom ne correspond à aucun role"
        theRole -> 
            if statutP pa == Connecter  
                then return $ Right $ paRole checkRole (code pa) 
            else return $ Left "cet utilisateur n'est pas connecté"

    -- fonction qui donne un role a un utilisateur type Operateur 

opRole :: Role -> Matricule -> Role
opRole r m =
    let var = ConsMatricule m : roleUserList r 
    in MkRole {nameRole = nameRole r , roleUserList =  var }
    
--fonction qui donne un role a un utilisateur type Patient 

paRole :: Role -> AccessCode -> Role
paRole role code =  
    let sortie = ConsAccessCode code  : roleUserList role   
    in MkRole {nameRole = nameRole role , roleUserList = sortie }
 


  

