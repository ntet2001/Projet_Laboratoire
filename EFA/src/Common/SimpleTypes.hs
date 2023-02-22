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

    {-======================== Types Definitions =============================-}

    data Categorie = Biochimie | Hematologie | Serologie | Parasitologie

    data Analyse = MkAnalyse {idAnalyse :: String,
        nomAnalyse :: String,
        valUsuel :: ValUsuel,
        categorie :: Categorie
    }


    data ValUsuel = Vide | UneVal | Interval Float Float


    data Fiche = MkFIche { idFiche::String,
        infoPatient :: InfoPatient,
        analyses :: [String],
        prescripteur :: String,
        date :: UTCTime
    }
 

    data InfoPatient = MkPatient { nom :: String,
        prenom :: String,
        datenaissance :: UTCTime,
        genre :: String, 
        email :: String
    }

