{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts, FlexibleInstances #-}
{-# LANGUAGE CPP, BangPatterns, ScopedTypeVariables #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
module Common.SimpleTypes where

    import Data.Time
    import Data.Aeson
    import Data.Aeson.TH
    import GHC.Generics
    import Text.ParserCombinators.Parsec
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result as R
    import Database.MySQL.Base.Types
    import qualified Data.ByteString.Char8 as C
    import qualified Data.ByteString.Lazy.Char8 as L

    ---------------------------------Type of Analyse --------------------------
    type IdAnalyse = String 

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

    -- instance QueryResults Analyse where
    --     convertResults [fa,fb,fc,fd] [va,vb,vc,vd] = MkAnalyse a b c d
    --         where   !a = R.convert fa va
    --                 !b = R.convert fb vb
    --                 !c = R.convert fc vc
    --                 !d = R.convert fd vd
    --     convertResults fs vs = convertError fs vs 4        
    ---------------------------------------------------------------------------
    
    type IdResult = Int
    type  IdFiche = Int

    data Results = MkResults{ idAnals :: Int
    , interpretations :: String
    , conclusions :: String
    , ficheId :: Int
    , prelevements :: UTCTime 
    , prescripteurs :: String
    , numDossiers :: Int 
    , lineresults :: [String]
    , nomLaborantins :: String
    } deriving (Eq, Show)
    $(deriveJSON defaultOptions ''Results)

    data InfoPatient = MkPatient {
        nom :: String,
        prenom :: String,
        datenaissance :: Int,
        genre :: String,
        email :: String
    } deriving (Show,Eq, Read, Generic)
    $(deriveJSON defaultOptions ''InfoPatient)
    
    --instance Show InfoPatient where
        --show infoPat = "Nom : " ++ (nom infoPat) ++ " " ++ (prenom infoPat) ++ "   Date naissance :  " ++ (show $ datenaissance infoPat) ++ "\ngenre : " ++ (genre infoPat) ++ "  email : " ++ (email infoPat)
    showFiche :: InfoPatient -> String 
    showFiche infoPat =  "Nom : " ++ (nom infoPat) ++ " " ++ (prenom infoPat) ++ "   Date naissance :  " ++ (show $ datenaissance infoPat) ++ "\ngenre : " ++ (genre infoPat) ++ "  email : " ++ (email infoPat)


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


    data LineResult = Negatif String | Positif String Float deriving (Show,Read,Eq,Generic)
    $(deriveJSON defaultOptions ''LineResult)

    instance  R.FromField [LineResult] where
       fromField = ([VarString], \someval -> do
            let tostring = C.unpack someval
            case tostring of
                "[]" -> Left "ne correspond pas a Negatif [Char] ou Positif Float"
                someString -> Right (read someString :: [LineResult]))

    instance R.Result [LineResult] where
        convert f Nothing =  error "erreur de Convertion sql de LineResult"
        convert f (Just xs) = let tostring = C.unpack xs
            in case tostring of
                "[]" -> error "ne correspond pas a Negatif [Char] ou Positif Float"
                someString -> read someString :: [LineResult]

    data Fiche = MkFIche { 
        idFiche :: Int,
        analyses :: [String],
        prescripteur :: String,
        date :: UTCTime,
        infoPatient :: InfoPatient,
        dateUpdate :: UTCTime
    } deriving (Show, Eq, Read, Generic)
    $(deriveJSON defaultOptions ''Fiche)

    instance R.Result [String] where
        convert f Nothing = error " erreur de Convertion sql d'analyse"
        convert f (Just xs) = let xs1 = C.unpack xs
            in case xs1 of
                [] -> error "erreur de Convertion sql d'analyse"
                ys -> read ys :: [String]

    instance R.Result Fiche where
        convert f Nothing = error " erreur de Convertion sql d'analyse"
        convert f (Just xs) = let xs1 = C.unpack xs
            in case xs1 of
                fiche -> read fiche :: Fiche
                _ -> error "erreur de Convertion sql d'analyse"

    instance FromField [String] where
        fromField = ([VarChar], \xs -> do
            let xs1 = C.unpack xs
            case xs1 of
                [] -> Left "erreur de Convertion sql d'analyse"
                ys -> Right (read ys :: [String])
            )

    instance FromField Fiche where
        fromField = ([VarChar], \xs -> do
            let xs1 = C.unpack xs
            case xs1 of
                fiche -> Right (read fiche :: Fiche)
                _ -> Left "erreur de Convertion sql d'analyse"
            )

    instance QueryResults Fiche where
        convertResults [fa,fb,fc,fd,fe,fg] [va,vb,vc,vd,ve,vg] = MkFIche a b c d e g
            where   !a = R.convert fa va
                    !b = R.convert fb vb
                    !c = R.convert fc vc
                    !d = R.convert fd vd
                    !e = R.convert fe ve
                    !g = R.convert fg vg
        convertResults fs vs = convertError fs vs 6

    data Rapport = MkRapport {
        idRapport :: Int,
        contenu :: [IdResult],
        fiche :: Fiche,
        dateCreatedRapport :: UTCTime,
        dateUpdatedRapport :: UTCTime
    }deriving (Show,Read,Eq,Generic)
    $(deriveJSON defaultOptions ''Rapport)

    instance FromField [Int] where
        fromField = ([VarChar], \xs -> do
            let xs1 = C.unpack xs
            case xs1 of
                [] -> Left "erreur de Convertion sql d'analyse"
                ys -> Right (read ys :: [Int])
            )

    instance R.Result [Int] where
        convert f Nothing = error " erreur de Convertion sql d'analyse"
        convert f (Just xs) = let xs1 = C.unpack xs
            in case xs1 of
                [] -> error "erreur de Convertion sql d'analyse"
                ys -> read ys :: [Int]

    instance QueryResults Rapport where
        convertResults [fa,fb,fc,fd,fe] [va,vb,vc,vd,ve] = MkRapport a b c d e
            where   !a = R.convert fa va
                    !b = R.convert fb vb
                    !c = R.convert fc vc
                    !d = R.convert fd vd
                    !e = R.convert fe ve
        convertResults fs vs = convertError fs vs 5

    data Resultat = MkResult {
        idResult :: Int,
        idAnal :: Int,
        interpretation :: String,
        conclusion :: String,
        fiche' :: IdFiche,
        prescripteurR :: String,
        numDossier :: Int,
        lineResults :: [LineResult],
        nomLaborantin :: String,
        dateCreatedResultat :: UTCTime,
        dateUpdatedResultat :: UTCTime
    } deriving (Show,Read,Eq,Generic)
    $(deriveJSON defaultOptions ''Resultat)

    showResultat :: Resultat -> String
    showResultat resultat = 
        let lineresults = fmap show (lineResults resultat)
        in (interpretation resultat) ++ " | " ++ (conclusion resultat) ++ " | " ++ (prescripteurR resultat) ++ " | " ++ (concat lineresults) ++ " | " ++ (nomLaborantin resultat) ++ "\n"

    instance QueryResults Resultat where
        convertResults [fa,fb,fc,fd,fe,ff,fg,fh,fi,fj,fk] [va,vb,vc,vd,ve,vf,vg,vh,vi,vj,vk] = MkResult a b c d e f g h i j k 
            where   !a = R.convert fa va
                    !b = R.convert fb vb
                    !c = R.convert fc vc
                    !d = R.convert fd vd
                    !e = R.convert fe ve
                    !f = R.convert ff vf
                    !g = R.convert fg vg
                    !h = R.convert fh vh
                    !i = R.convert fi vi
                    !j = R.convert fj vj
                    !k = R.convert fk vk
        convertResults fs vs = convertError fs vs 11

    
