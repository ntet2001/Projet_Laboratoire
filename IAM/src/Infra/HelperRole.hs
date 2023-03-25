module Infra.HelperRole where 

import Common.SimpleType
import System.IO
import Infra.FunctionsInfra



-- la liste des roles ou codeAccess des utulisateurs est dans un contexte

-- fonction qui ressort la liste des nom de role joues par un operateur 

-- fonction qui ressort la liste des noms de role joués par utilisateur type operateur 

opSearchRoleHelper :: Operateur -> String -> IO [NomRole] -- IO [Maybe NomRole] est plus facile a gerer
opSearchRoleHelper  x file = do
    fileContent <- readFile file
    let lignes = lines fileContent
        toRole = fmap read lignes :: [Role]
        lookingForRole = fmap (f (matricule x)) toRole   
    return $ concat lookingForRole
    where f :: Matricule -> Role -> [NomRole]
          f m rl = do
            let listofId = roleUserList rl 
            if ConsMatricule m `elem` listofId 
                then return $ nameRole rl
            else []

-- fonction qui ressort la liste des noms de role joué par un patient 

paSearchRoleHelper :: Patient -> FilePath -> IO [NomRole]
paSearchRoleHelper y file = do 
    fileContent <- readFile file
    let lignes = lines fileContent
        toRole = fmap read lignes :: [Role]
        lookingforRole = fmap (g (nameOf y ++ " " ++ firstNameOf y)) toRole
    return $ concat lookingforRole
    where g :: String -> Role -> [NomRole] 
          g name role = do
            let var = roleUserList role  
            if ConsAccessCode name `elem` var 
                then return $ nameRole role
            else []

    
-- fonction qui ressort le role correspondant à un nom de role donné 

matchRole :: NomRole -> FilePath -> IO Role
matchRole nom file = do
    handle <- openFile file ReadMode
    lectureFichier <- contenuOp handle
    let toRole = fmap read lectureFichier :: [Role]
        liste =  filter (\r -> (getNom $ nameRole r) == (getNom nom)) toRole--[role | role <- toRole, nameRole role == nom]
    --print liste
    if null liste
        then fail "ce nom ne correspond a aucun role" 
        else do 
            hClose handle
            return $ head liste 