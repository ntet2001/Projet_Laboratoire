{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE BlockArguments #-}
{-# OPTIONS_GHC -Wno-unused-do-bind #-}
--{-# MINIMAL convertResluts #-}

module Common.SimpleTypes where

    {-======================== Modules Importations ==========================-}
    import GHC.Generics
    import Data.Aeson
    import Data.Aeson.TH
    import Data.Time
    import Data.Aeson 
    import Database.MySQL.Simple.QueryResults 
    import qualified Database.MySQL.Simple.Result as R
    import Data.ByteString.Char8 
    import Database.MySQL.Simple.Types
    import Database.MySQL.Base.Types
    import Text.ParserCombinators.Parsec

    {-======================== Types Definitions =============================-}


    type IdAnalyse = String 

    data Categorie = Biochimie | Hematologie | Serologie | Parasitologie deriving ( Eq, Read, Show)


    data Analyse  = MkAnalyse {
        idAnalyse :: IdAnalyse,
        nomAnalyse :: String,
        valUsuel :: ValUsuel,
        categorie :: Categorie
    } deriving (Show, Eq, Read)


    data Fiche = MkFIche { 
        idFiche :: Int,
        infoPatient :: InfoPatient,
        analyses :: [String],
        prescripteur :: String,
        date :: UTCTime 
    } deriving (Show, Eq, Read)


    data InfoPatient = MkPatient { nom :: String,
        prenom :: String,
        datenaissance :: Year,
        genre :: String, 
        email :: String
    } deriving (Show, Eq, Read)


    data ValUsuel  = Vide | UneVal Float  | Interval Float Float deriving (Eq, Read, Show)


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


    -- instance Show ValUsuel where
    --     show Vide = "Vide"
    --     show (UneVal a) = "UneVal " ++ show a 
    --     show (Interval b c) = "Interval " ++ show c ++ " " ++ show b 
    
    instance R.Result ValUsuel
    instance R.Result Categorie

    instance  R.FromField ValUsuel  where
       fromField = ([VarString], \someval -> do
            let tostring = unpack someval
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
            let act1 = unpack cat
            case act1 of
                "Biochimie" -> Right Biochimie
                "Hematologie" -> Right Hematologie
                "Serologie" -> Right Serologie
                "Parasitologie" -> Right Parasitologie
                _ -> Left "Categorie incorrecte")
    

    -- instance  QueryResults Analyse where
    -- convertResults :: [Field] -> [Maybe ByteString] -> Analyse
    -- convertResults [fa,fb,fc,fd] [va,vb,vc,vd] = MkAnalyse a b c d
    --     where !a = R.convert fa va
    --           !b = R.convert fb vb
    --           !c = R.convert fc vc
    --           !d = R.convert fd vd
    -- convertResults fs vs  = convertError fs vs 4


    -- instance  Q.QueryResults (Only Categorie) where
    -- convertResults' [fa] [va] = Only a
    --     where !a = R.convert fa va
    -- convertResults' fs vs  = Q.convertError fs vs 1

    -- instance Q.QueryResults (Only ValUsuel) where
    -- convertResults1 [fa] [va] = Only a
    --     where !a = R.convert fa va
    -- convertResults1 fs vs  = Q.convertError fs vs 1


    
    -- instance R.Result Categorie
    -- -- instance QueryResults (Only Categorie)
    -- -- instance QueryResults (Only ValUsuel) 

    
    
    -- 
