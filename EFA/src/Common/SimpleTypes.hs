{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Common.SimpleTypes where

    {-======================== Modules Importations ==========================-}
    import GHC.Generics
    import Data.Aeson
    import Data.Aeson.TH
    import Network.Wai
    import Network.Wai.Handler.Warp
    import Servant
    import qualified Data.Text as T 
    import Data.Time
    import Data.Aeson 
    import GHC.Generics

    {-======================== Types Definitions =============================-}

    data Categorie = Biochimie | Hematologie | Serologie | Parasitologie deriving (Show, Eq, Read)

    data Analyse a = MkAnalyse {idAnalyse :: String,
        nomAnalyse :: String,
        valUsuel :: ValUsuel a,
        categorie :: Categorie
    } deriving (Show, Eq, Read)


    data ValUsuel a  = Vide | UneVal a  | Interval Float Float deriving (Show, Eq, Read)


    data Fiche = MkFIche { idFiche::String,
        infoPatient :: InfoPatient,
        analyses :: [String],
        prescripteur :: String,
        date :: UTCTime 
    } deriving (Show, Eq, Read, Generic)

    instance ToJSON Fiche 
    instance FromJSON Fiche 
 

    data InfoPatient = MkPatient { nom :: String,
        prenom :: String,
        datenaissance :: UTCTime,
        genre :: String, 
        email :: String
    } deriving (Show, Eq, Read, Generic)

    instance ToJSON InfoPatient
    instance FromJSON InfoPatient




