{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
module Infra.AssignRole where 

import Common.SimpleType
import Infra.HelperRole
import Infra.FunctionsInfra (contenuOp)
import System.IO


-- fonction qui assigne un role a un utilisateur connecté

asignRole :: NomRole -> User Operateur Patient -> IO Role
asignRole someName  (Operateur op) = do  
    print someName
    handle <- openFile "roles.txt" ReadMode
    fileContent <- contenuOp handle
    hClose handle
    checkRole <- matchRole someName "roles.txt"
    let assignedRole = opRole checkRole (matricule op)
        toRole = fmap read fileContent :: [Role]
        updateFile = f assignedRole toRole
    writeFile  "roles.txt" $ unlines $ fmap show updateFile 
    --putStrLn $ show checkRole
    return assignedRole
asignRole someName (Patient pa ) = do 
    handle1 <- openFile "roles.txt" ReadMode
    contenu <- contenuOp handle1
    hClose handle1
    checkRole' <- matchRole someName "roles.txt"
    let assignedRolePa = paRole checkRole' (nameOf pa ++ " " ++ firstNameOf pa)
        toRole' = fmap read contenu :: [Role]
        updateFile' = f assignedRolePa toRole'
    print updateFile'
    writeFile "roles.txt" $ unlines $ fmap show updateFile'
    return assignedRolePa
         

    -- fonction qui donne un role a un utilisateur type Operateur 
opRole :: Role -> Matricule -> Role
opRole r m = if  ConsMatricule m `elem` roleUserList r 
                then r
             else MkRole {nameRole = nameRole r , roleUserList =  ConsMatricule m : roleUserList r }
    
--fonction qui donne un role a un utilisateur type Patient 

paRole :: Role -> String -> Role
paRole role name =  if ConsAccessCode name `elem` roleUserList role  
                        then role  
                    else MkRole {nameRole = nameRole role , roleUserList = ConsAccessCode name : roleUserList role}


--fonction qui met a jour le contenu du fichier 

f :: Role -> [Role] -> [Role]
f unRole [] = []
f unRole (x:xs) = if nameRole unRole == nameRole x 
                        then unRole:xs
                  else x : f unRole xs

 


  

