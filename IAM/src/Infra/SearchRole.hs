{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use lambda-case" #-}
module Infra.SearchRole where


import Common.SimpleType
import Infra.HelperRole
import Infra.ReadPatient
import Infra.ReadOperateur
import Control.Monad.IO.Class (liftIO)
import Control.Monad 
--import Control.Monad.Cont (sequence)



-- fonction qui ressort la liste de tous les role joués par un utilisateur 

searchRole :: User Operateur Patient -> String -> IO [NomRole]
searchRole (Operateur x) file = do
     opSearchRoleHelper x file
searchRole (Patient y) file = do
    paSearchRoleHelper y file


-- fonction qui ressort tous les roles existants

listOfRoles :: IO [Role]
listOfRoles = do
     contenu <- readFile "roles.txt"
     let lignes = lines contenu
         toRole = fmap read lignes :: [Role]
     return toRole

-- fonction qui ressort  la liste des utilisateurs qui jouent un role

userRoles :: NomRole -> IO [User Operateur Patient]
userRoles namerole = do
     -- je ressort le role qui corresponad au nom en parametre
     roleCorrespondant <- matchRole namerole "roles.txt"
     -- la liste des access code des utilisateurs qui jouent le role
     let listOfAccess = roleUserList roleCorrespondant
         listOfUserIO = fmap (\userid -> do 
               case userid of
                    ConsMatricule x -> do 
                         op <- foundOperator x
                         return $ Operateur op
                    ConsAccessCode y -> do 
                         pt <- readByName y
                         return $ Patient pt) listOfAccess
     sequence listOfUserIO    
    