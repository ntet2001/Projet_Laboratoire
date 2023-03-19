
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}

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

    data Email2 = MkEmail2 
        {identifiant2 :: Identifiant
        ,domaine2 :: String
        ,extension2 :: String 
        } deriving (Eq,Read,Generic)
    $(deriveJSON defaultOptions ''Email2)

    instance Show Email2 where
        show email = (identifiant2 email) ++ "@" ++ (domaine2 email) ++ "." ++ (extension2 email)

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

    data Operateur2 = MKOperateur2 
        { nomOp2 :: NomOp
        ,prenomOp2 ::  PrenomOp
        ,matricule2 :: Matricule
        ,email2 :: Email2
        ,passwordOp2 :: PasswordOp
        ,photo2 :: Photo
        ,statutOp2 :: Statut 
        } deriving (Show,Eq,Read,Generic)
    $(deriveJSON defaultOptions ''Operateur2)
    
    data Patient = MkPatient 
        {nameOf :: Nom
        ,firstNameOf :: Nom
        ,emailOf :: Email
        ,photoOf :: Photo
        ,code :: Int
        ,statutP :: Statut
        } deriving (Show, Read,Eq,Generic)
    $(deriveJSON defaultOptions ''Patient)

    data Patient2 = MkPatient2 
        {nameOf2 :: Nom
        ,firstNameOf2 :: Nom
        ,emailOf2 :: Email2
        ,photoOf2 :: Photo
        ,code2 :: Int
        ,statutP2 :: Statut
        } deriving (Show, Read,Eq,Generic)
    $(deriveJSON defaultOptions ''Patient2)
    
    data Access e f = ConsMatricule e | ConsAccessCode  f deriving (Show, Read, Eq, Generic)
    $(deriveJSON defaultOptions ''Access)
    
    newtype NomRole = MkNom {getNom :: String}  deriving (Show, Read, Eq, Generic)
    $(deriveJSON defaultOptions ''NomRole)

    data User a b  = Operateur a   | Patient b  deriving (Show , Read , Eq, Generic)
    $(deriveJSON defaultOptions ''User)

    data Role = MkRole {nameRole :: NomRole, roleUserList :: [Access Matricule AccessCode] } deriving (Show, Read, Eq, Generic)
    $(deriveJSON defaultOptions ''Role)

    

    --instance ToJSON Role
    --instance ToJSON NomRole
    --instance ToJSON (Access Matricule AccessCode) 
    --instance FromHttpApiData NomRole


