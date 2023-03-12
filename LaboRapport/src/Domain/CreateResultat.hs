module Domain.CreateResultat where

import Common.SimpleTypes
import Data.Time (UTCTime, getCurrentTime)
import qualified Text.ParserCombinators.Parsec as P
import Control.Monad.IO.Class (MonadIO(liftIO))
import Control.Applicative 

-- type du domaine : IdFiche, Prescripteur, Date, DateOfBirth... 

type Genre = String
type DateOfBirth = Int
type Nom = String

type IdAnal = Int
--stype IdResult = Int
type Interpretation = String
type Conclusion = String
type Prelevement = UTCTime
type DateCreatedResultat = UTCTime
type DateUpdatedResultat = UTCTime
type Prescripteur = String
type NumDossier = Int
type NomLaborantin = String


{-===== verifications du domaine : -}

-- verification generale des types string : ne contient que les lettres de l'alphabet francais
someParser :: P.Parser String
someParser = do
    many (P.oneOf $ mappend ['a'..'z'] ['A'..'Z'])
    
verifString :: String -> Either P.ParseError String
verifString = P.parse someParser "ne doit contenir que des lettres de l'alphabet francais"

-- verification de la date de naissance et de l'id de la fiche : ne doit pas etre negatif

parserInt :: P.Parser Int
parserInt = do
     someVar <- P.many (P.oneOf ['0'..'9'])
     return (read someVar :: Int)

verifInt :: String ->  Either P.ParseError Int 
verifInt = P.parse parserInt "une date de naissance doit etre positive"

-- checking input int
alwaysPositifs :: IdAnal -> IdResult -> NumDossier -> Either P.ParseError (IdAnal, IdResult, NumDossier)
alwaysPositifs x y z = (, , ) <$> verifInt (show x) <*>
                                  verifInt (show y) <*>
                                  verifInt (show z)

-- checking input string 
correctString :: Interpretation -> Conclusion -> Prescripteur -> NomLaborantin -> Either P.ParseError (Interpretation, Conclusion, Prescripteur, NomLaborantin)
correctString i j k l = (, , ,)  <$> verifString i <*>
                                     verifString j <*> 
                                     verifString k <*> 
                                     verifString l


--data LineResult = Negatif String | Positif String Float
checkLineResult :: String -> Either String LineResult
checkLineResult line = 
    let a = takeWhile (/= ' ') line
        lna = length a
        rest =  drop (lna + 1) line
        b = takeWhile (/= ' ') rest
        lnb = length b
        rest1 =  drop (lnb + 1) rest
    in case a of
        "Negatif" -> Right (Negatif rest)
        "Positif" -> Right (Positif b (read rest1 :: Float))
        _ -> Left "LineResult invalide"         

createResultat :: IdResult -> IdAnal -> Interpretation -> Conclusion -> IdFiche -> Prescripteur -> NumDossier
    -> [LineResult] -> NomLaborantin -> IO Resultat
createResultat idR idA interpret conclusion someIdFiche  somebody somenumber xs technicienLabo  = do
    time <- getCurrentTime
    return $ createResultatHelper idR idA interpret conclusion someIdFiche somebody somenumber xs technicienLabo time time


createResultatHelper :: IdResult -> IdAnal -> Interpretation -> Conclusion -> IdFiche -> Prescripteur -> NumDossier
    -> [LineResult] -> NomLaborantin -> DateCreatedResultat -> DateUpdatedResultat -> Resultat
createResultatHelper = MkResult