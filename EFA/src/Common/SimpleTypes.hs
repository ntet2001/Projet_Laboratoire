{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE BlockArguments #-}
{-# OPTIONS_GHC -Wno-unused-do-bind #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts, FlexibleInstances #-}
{-# LANGUAGE CPP, BangPatterns, ScopedTypeVariables #-}

module Common.SimpleTypes where

    {-======================== Modules Importations ==========================-}
    import Data.Aeson.TH
    import Data.Time
    import Data.Aeson 
    import Text.ParserCombinators.Parsec
    import GHC.Generics
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result as R
    import Database.MySQL.Base.Types
    import qualified Data.ByteString.Char8 as C
    import Data.Time (UTCTime, Day)
    {-======================== Types Definitions =============================-}


    type IdAnalyse = String 

    data SemiPatient = ConsP {newNom :: String, newPrenom :: String , newMail :: String} deriving (Show, Eq, Read)
    $(deriveJSON defaultOptions ''SemiPatient)

    data Together = ConsT {nomPatient :: String , newParams :: SemiPatient} deriving (Show, Eq, Read)
    $(deriveJSON defaultOptions ''Together)


    data ValUsuel  = Vide | UneVal Float  | Interval Float Float deriving (Eq, Read, Show)
    $(deriveJSON defaultOptions ''ValUsuel)


    data Categorie = Biochimie | Hematologie | Serologie | Parasitologie deriving ( Eq, Read, Show)
    $(deriveJSON defaultOptions ''Categorie)


    data Analyse  = MkAnalyse {
        idAnalyse :: IdAnalyse,
        nomAnalyse :: String,
        valUsuel :: ValUsuel,
        categorie :: Categorie
    } deriving (Show, Eq, Read)
    $(deriveJSON defaultOptions ''Analyse)

    data Analyse2  = MkAnalyse2 {
        nomAnalyse2 :: String,
        valUsuel2 :: ValUsuel,
        categorie2 :: Categorie
    } deriving (Show, Eq, Read)
    $(deriveJSON defaultOptions ''Analyse2)

    
    data InfoPatient = MkPatient { 
        nom :: String,
        prenom :: String,
        datenaissance :: Int,
        genre :: String, 
        email :: String
    } deriving (Show, Eq, Read, Generic )
    $(deriveJSON defaultOptions ''InfoPatient)

    data Fiche = MkFIche { 
        idFiche :: Int,
        analyses :: [String],
        prescripteur :: String,
        date :: UTCTime,
        patientInfos :: InfoPatient,
        dateUpdate :: UTCTime
    } deriving (Show, Eq, Read, Generic)
    $(deriveJSON defaultOptions ''Fiche)

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

    

    instance FromField [String] where
        fromField = ([VarChar], \xs -> do
            let xs1 = C.unpack xs
            case xs1 of
                [] -> Left "erreur de Convertion sql d'analyse"
                ys -> Right (read ys :: [String])
            )




    -- parser d'une valeur usuelle

    parserUneVal :: Parser Float
    parserUneVal = do
        char 'U' >> char 'n' >> char 'e' >> char 'V' >> char 'a' >> char 'l' >> space
        valeurUsuelle <- many (digit <|> char '.')
        let sortie = read valeurUsuelle :: Float
        return sortie

    parserInterval :: Parser (Float, Float)
    parserInterval = do
        char 'I' >> char 'n' >> char 't' >> char 'e' >> char 'r' >> char 'v' >> 
         char 'a' >> char 'l' >> space 
        min' <- many (digit <|> char '.')
        space 
        max' <- many (digit <|> char '.')
        let sortie = (read min' :: Float, read max' :: Float)
        return sortie

    
    -- -- fonction qui fait le parsing
    fUneVal :: String -> Either ParseError Float
    fUneVal = parse parserUneVal "ce n'est pas un element de type ValUsuel"


    fInterval :: String -> Either ParseError (Float,Float)
    fInterval = parse parserInterval "ce n'est pas un element de type ValUsuel"
    
    instance R.Result ValUsuel
    instance R.Result Categorie

    instance  R.FromField ValUsuel  where
       fromField = ([VarString], \someval -> do
            let tostring = C.unpack someval
            case tostring of 
                "Vide" -> Right Vide
                someString -> do
                    let parsing = fUneVal someString
                    case parsing of
                        Right someFloat -> Right $ UneVal someFloat
                        Left _ -> do 
                                let otherparsing = fInterval someString
                                case otherparsing of
                                    Right (x,y) -> Right $ Interval x y
                                    Left _ -> Left "cette valeur n'est pas du type ValUsuel" )

    instance R.FromField Categorie where
        fromField = ([VarString], \cat -> do
            let act1 = C.unpack cat
            case act1 of
                "Biochimie" -> Right Biochimie
                "Hematologie" -> Right Hematologie
                "Serologie" -> Right Serologie
                "Parasitologie" -> Right Parasitologie
                _ -> Left "Categorie incorrecte")

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


