{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts, FlexibleInstances #-}
{-# LANGUAGE CPP, BangPatterns, ScopedTypeVariables #-}
module Common.SimpleTypes where

    {-======================== Modules Importations ==========================-}
    import Data.Aeson.TH
    import Network.Wai
    import Network.Wai.Handler.Warp
    import Servant
    import qualified Data.Text as T 
    import Data.Time
    import Data.Aeson 
    import GHC.Generics
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result as R
    import Database.MySQL.Base.Types
    import qualified Data.ByteString.Char8 as C
    import Data.Time (UTCTime, Day)
    {-======================== Types Definitions =============================-}

    data Categorie = Biochimie | Hematologie | Serologie | Parasitologie deriving (Show, Eq, Read)

    data Analyse a = MkAnalyse {idAnalyse :: Int,
        nomAnalyse :: String,
        valUsuel :: ValUsuel a,
        categorie :: Categorie
    } deriving (Show, Eq, Read)


    data ValUsuel a  = Vide | UneVal a  | Interval Float Float deriving (Show, Eq, Read)

    data InfoPatient = MkPatient { nom :: String,
        prenom :: String,
        datenaissance :: Int,
        genre :: String, 
        email :: String
    } deriving (Show, Eq, Read, Generic)
    $(deriveJSON defaultOptions ''InfoPatient)

    instance FromField InfoPatient where
        fromField = ([VarString], \xs -> do
            let xs' = C.unpack xs
            case xs' of
                ys -> Right (read ys :: InfoPatient)
                _ -> Left "erreur de Convertion sql d'analyse"
            )

    instance R.Result InfoPatient where
        convert f Nothing =  error "erreur de Convertion sql d'analyse"
        convert f (Just xs) = let xs' = C.unpack xs
            in case xs' of
                ys -> read ys :: InfoPatient
                _ -> error "erreur de Convertion sql d'analyse"

    instance QueryResults InfoPatient where
        convertResults [fa,fb,fc,fd,fe] [va,vb,vc,vd,ve] = MkPatient a b c d e
            where   !a = R.convert fa va
                    !b = R.convert fb vb 
                    !c = R.convert fc vc
                    !d = R.convert fd vd
                    !e = R.convert fe ve
        convertResults fs vs = convertError fs vs 5

    data Fiche = MkFIche { 
        idFiche :: Int,
        analyses :: [String],
        prescripteur :: String,
        date :: UTCTime,
        infoPatient :: InfoPatient,
        dateUpdate :: UTCTime
    } deriving (Show, Eq, Read, Generic)
    $(deriveJSON defaultOptions ''Fiche)

    instance FromField [String] where
        fromField = ([VarChar], \xs -> do
            let xs1 = C.unpack xs
            case xs1 of
                [] -> Left "erreur de Convertion sql d'analyse"
                ys -> Right (read ys :: [String])
            )

    instance R.Result [String] where
        convert f Nothing = error" erreur de Convertion sql d'analyse"
        convert f (Just xs) = let xs1 = C.unpack xs
            in case xs1 of
                [] -> error "erreur de Convertion sql d'analyse"
                ys -> read ys :: [String]

    instance QueryResults Fiche where
        convertResults [fa,fb,fc,fd,fe,fg] [va,vb,vc,vd,ve,vg] = MkFIche a b c d e g
            where   !a = R.convert fa va
                    !b = R.convert fb vb 
                    !c = R.convert fc vc
                    !d = R.convert fd vd
                    !e = R.convert fe ve
                    !g = R.convert fg vg
        convertResults fs vs = convertError fs vs 6





