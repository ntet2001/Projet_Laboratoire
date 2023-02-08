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

    -- instance Show Email where
    --     show email = (identifiant email) ++ "@" ++ (domaine email) ++ "." ++ (extension email)

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

    data Role = MkRole {nameRole :: NomRole, roleUserList :: Access ListMatricule ListAccessCode } deriving (Show, Read, Eq)

    type ListMatricule = [Matricule]

    type ListAccessCode = [Int] 
    
    data Access e f = ListMatricule e | ListAccessCode  f deriving (Show, Read, Eq)
    data NomRole = Admin | Laborantain | Secretaire | SimplePatient  deriving (Show, Read, Eq)
