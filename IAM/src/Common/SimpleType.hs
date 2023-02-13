{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Common.SimpleType where

    {---------------------------=== Importation ===----------------------------------}
    import qualified Data.Text as C    
    import GHC.Generics
    import Data.Aeson
    import Data.Aeson.TH
    import Network.Wai
    import Network.Wai.Handler.Warp
    import Servant

    {---------------------------=== Types Definitions ===---------------------------}
    type Nom = String 
    type NomOp = Nom 
    type PrenomOp = Nom 
    type NomPatient = Nom
    type PrenomPatient = Nom
    type Matricule = String
    type Identifiant = String
    data Statut = Connecter | Deconnecter | Supprimer | Bloquer | Aucun deriving (Show,Eq,Read,Generic)
    $(deriveJSON defaultOptions ''Statut)

    data Email = MkEmail 
        {identifiant :: Identifiant
        ,domaine :: String
        ,extension :: String 
        } deriving (Show,Eq,Read,Generic)
    $(deriveJSON defaultOptions ''Email)

    type AccessCode = Int 
    type PasswordOp = String
    type Photo = C.Text
    data Operateur = MKOperateur 
        { nomOp :: NomOp
        ,prenomOp ::  PrenomOp
        ,matricule :: Matricule
        ,email :: Email
        ,passwordOp :: PasswordOp
        ,photo :: Photo
        ,statutOp :: Statut 
        } deriving (Show,Eq,Read,Generic)
    $(deriveJSON defaultOptions ''Operateur)
    
    data Patient = MkPatient 
        {nameOf :: Nom
        ,firstNameOf :: Nom
        ,emailOf :: Email
        ,photoOf :: Photo
        ,code :: Int
        ,statutP :: Statut
        } deriving (Show, Read,Eq,Generic)
    $(deriveJSON defaultOptions ''Patient)
    
    data User a b  = Operateur a   | Patient b  deriving (Show , Read , Eq)

    data Role = MkRole {nameRole :: NomRole, roleUserList :: [Access Matricule AccessCode] } deriving (Show, Read, Eq)

    data Access e f = ConsMatricule e | ConsAccessCode  f deriving (Show, Read, Eq)
    newtype NomRole = MkNom {getNom :: String}  deriving (Show, Read, Eq)
    