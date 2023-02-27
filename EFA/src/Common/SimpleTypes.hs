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

    data Analyse a = MkAnalyse {idAnalyse :: Int,
        nomAnalyse :: String,
        valUsuel :: ValUsuel a,
        categorie :: Categorie
    } deriving (Show, Eq, Read)


    data ValUsuel a  = Vide | UneVal a  | Interval Float Float deriving (Show, Eq, Read)


    data Fiche = MkFIche { 
        idFiche :: Int,
        infoPatient :: InfoPatient,
        analyses :: [String],
        prescripteur :: String,
        date :: UTCTime 
    } deriving (Show, Eq, Read, Generic)


    data InfoPatient = MkPatient { nom :: String,
        prenom :: String,
        datenaissance :: Year,
        genre :: String, 
        email :: String
    } deriving (Show, Eq, Read, Generic)





