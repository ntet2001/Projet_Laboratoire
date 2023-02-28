{-# LANGUAGE DataKinds, BangPatterns       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators, DeriveGeneric #-}
module Common.SimpleTypes where

    {-======================== Modules Importations ==========================-}
    import GHC.Generics
    import Data.Aeson (ToJSON, FromJSON)
    import Data.Aeson.TH
    import Network.Wai
    import Network.Wai.Handler.Warp
    import Servant
    import qualified Data.Text as T 
    import Data.Time
    import GHC.Generics
    import Data.Typeable
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result
    import qualified Data.ByteString.Char8 as C
    import Database.MySQL.Base.Types

    {-======================== Types Definitions =============================-}

    data Categorie = Biochimie | Hematologie | Serologie | Parasitologie deriving (Show, Eq, Read,Generic,Typeable)

    type NomAnalyse = String 
    type IdAnalyse = String 
    data Analyse = MkAnalyse {idAnalyse :: IdAnalyse,
        nomAnalyse :: NomAnalyse,
        valUsuel :: ValUsuel,
        categorie :: Categorie
    } deriving (Show, Eq, Read, Generic, Typeable)

    -- instance ToJSON Categorie 
    -- instance FromJSON Categorie
    -- instance ToJSON ValUsuel 
    -- instance FromJSON ValUsuel
    -- instance ToJSON Analyse 
    -- instance FromJSON Analyse

    type Max = Float
    type Min = Float
    data ValUsuel =  Vide | UneValFloat Float | UneValString String  | Interval Min Max deriving (Show, Eq, Read, Generic,Typeable)

       
    type Prescripteur = String
    type ListA = [IdAnalyse]
    data Fiche = MkFIche { idFiche::String,
        infoPatient :: InfoPatient,
        analyses :: ListA,
        prescripteur :: Prescripteur,
        date :: Day 
    } deriving (Show, Eq, Read, Generic,Typeable)

    instance ToJSON Fiche 
    instance FromJSON Fiche

    instance ToJSON GenreP 
    instance FromJSON GenreP 
 
    type NomP = String
    type PrenomP = String
    type EmailP = String
    data GenreP = Masculin | Feminin deriving (Show, Eq, Read, Generic,Typeable)
    data InfoPatient = MkPatient { nomP :: NomP ,
        prenomP :: PrenomP,
        datenaissanceP :: Day,
        genreP :: GenreP, 
        emailP :: String
    } deriving (Show, Eq, Read, Generic,Typeable)

    instance ToJSON InfoPatient
    instance FromJSON InfoPatient

    instance FromField Categorie where
    fromField = ([VarString], \cat -> do
        let cat1 = C.unpack cat
        case cat1 of
            "Biochimie" -> Right Biochimie 
            "Hematologie" -> Right Hematologie
            "Serologie" -> Right Serologie
            "Parasitologie" -> Right Parasitologie  
            _ -> Left "Categorie incorrect")

    instance FromField ValUsuel where
        fromField = ([VarString], \val -> do
            let val1 = C.unpack val
            case val1 of
                "Vide" -> Right Vide
                a -> let b = takeWhile (/= ' ') a
                         lnB = length b
                         rest = drop (lnB+1) a
                    in if b == "UneValFloat" then
                            Right (UneValFloat (read rest :: Float))
                            else if b == "UneValString" then
                            Right (UneValString rest)
                            else if b == "Interval" then
                                let min = takeWhile (/= '-') rest
                                    linMin = length min
                                    max = drop (linMin+1) rest
                                in Right (Interval (read min :: Float) (read max :: Float))
                                else Left "ValUsuel invalide")


    instance Result Categorie where
        convert x Nothing = error "Categorie invalide"  
        convert x (Just y) = do
            let cat = C.unpack y
            case cat of
                "Biochimie" ->  Biochimie 
                "Hematologie" ->  Hematologie
                "Serologie" ->  Serologie
                "Parasitologie" ->  Parasitologie  
                _ -> error "Categorie incorrect"

    instance Result ValUsuel where
        convert x Nothing = error "ValUsuel invalide"  
        convert x (Just y) = 
            let val = C.unpack y
            in case val of
                "Vide" ->  Vide
                a -> let b = takeWhile (/= ' ') a
                         lnB = length b
                         rest = drop (lnB+1) a
                    in if b == "UneValFloat" then
                            (UneValFloat (read rest :: Float))
                            else if b == "UneValString" then
                            (UneValString rest)
                            else if b == "Interval" then
                                let min = takeWhile (/= '-') rest
                                    linMin = length min
                                    max = drop (linMin+1) rest
                                in (Interval (read min :: Float) (read max :: Float))
                                else error "ValUsuel invalide"






    instance QueryResults Analyse where
        convertResults [fa,fb,fc,fd] [va,vb,vc,vd] = MkAnalyse a b c d
                where !a = convert fa va
                      !b = convert fb vb
                      !c = convert fc vc
                      !d = convert fd vd
        convertResults fs vs  = convertError fs vs 4




