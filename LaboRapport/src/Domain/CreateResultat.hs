module Domain.CreateResultat where

import Common.SimpleTypes
import Data.Time (UTCTime, getCurrentTime)
import Text.ParserCombinators.Parsec
import Control.Monad.IO.Class (MonadIO(liftIO))

-- type du domaine : IdFiche, Prescripteur, Date, DateOfBirth... 

type Genre = String
type DateOfBirth = Int
type Nom = String



{-===== verifications du domaine : -}

-- verification generale des types string : ne contient que les lettres de l'alphabet francais
someParser :: Parser String
someParser = do
    many (oneOf $ mappend ['a'..'z'] ['A'..'Z'])
    
verifString :: String -> Either ParseError String
verifString = parse someParser "ne doit contenir que des lettres de l'alphabet francais"

-- verification de la date de naissance et de l'id de la fiche : ne doit pas etre negatif

parserInt :: Parser Int
parserInt = do
     someVar <- many (oneOf ['0'..'9'])
     return (read someVar :: Int)

verifInt :: String ->  Either ParseError Int 
verifInt = parse parserInt "une date de naissance doit etre positive"


{-=== fonction du domaine pour creer une fiche ===-}

-- fonction qui construit les informations d'un patient

patientCheck  :: Nom -> Nom -> DateOfBirth -> Genre -> String -> Either ParseError InfoPatient
patientCheck  name postName birthDay genre email =
     MkPatient <$> verifString name <*>
                   verifString postName <*>
                   verifInt (show birthDay) <*>
                   verifString genre <*>
                   verifString email 
-- IAM se charge de verifier en profondeur l'email, EFA verifie juste si c'est une chaine non vide

-- fonction qui cree un resultat
--idR idA interpre conclu prescrip numD linesR nomLabo
data ResultatH = MkResultH { 
    idResultH :: IdResultat,
    idAnalH :: IdAnalyse,
    interpretationH :: Interpretation,
    conclusionH :: Conclusion,
    prescripteurH :: Prescripteur,
    numDossierH :: NumDossier,
    nomLaborantinH :: NomLaborantin
}
type IdAnalyse = Int
type IdResultat = Int
type Interpretation = String
type Conclusion = String
type Prelevement = UTCTime
type Prescripteur = String
type NumDossier = Int
type NomLaborantin = String

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


createResultatH :: IdResultat -> IdAnalyse -> Interpretation -> Conclusion -> Prescripteur -> NumDossier -> NomLaborantin -> Either ParseError ResultatH 
createResultatH idR idA interpre conclu prescrip numD nomLabo =
    MkResultH <$> verifInt (show idR) <*>
                  verifInt (show idA) <*>
                  verifString interpre <*>
                  verifString conclu <*>   
                  verifString prescrip <*>
                  verifInt (show numD) <*>
                  verifString nomLabo