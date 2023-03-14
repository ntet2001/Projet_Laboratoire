module Domain.CreateFiche where

import Common.SimpleTypes
import Data.Time (UTCTime, getCurrentTime)
import Text.ParserCombinators.Parsec
import Control.Monad.IO.Class (MonadIO(liftIO))

-- type du domaine : IdFiche, Prescripteur, Date, DateOfBirth... 

type Date = UTCTime
type Prescripteur = String
type Genre = String
type DateOfBirth = Int
type Nom = String
type IdFiche = Int

{-===== verifications du domaine : -}

-- verification generale des types string : ne contient que les lettres de l'alphabet francais
someParser :: Parser String
someParser = do
    many (oneOf $ mappend ['a'..'z'] ['A'..'Z'])
    
verifString :: String -> Either ParseError String
verifString = parse someParser "ne doit contenir que des lettres de l'aphabet francais"

-- verification de la date de naissance et de l'id de la fiche : ne doit pas etre negatif

parserInt :: Parser Int
parserInt = do
     someVar <- many (oneOf ['0'..'9'])
     return (read someVar :: Int)

verifInt :: String ->  Either ParseError Int 
verifInt = parse parserInt "une date de naissance doit etre positive"


{-=== fonction du domaine pour creer une fiche ===-}

parserDeEmail :: Parser String
parserDeEmail = do 
    many anyChar

verifDeEmail :: String -> Either ParseError String
verifDeEmail = parse parserDeEmail "bad email"

-- fonction qui construit les informations d'un patient

patientCheck  :: Nom -> Nom -> DateOfBirth -> Genre -> String -> Either ParseError InfoPatient
patientCheck  name postName birthDay genre email =
     MkPatient <$> verifString name <*>
                   verifString postName <*>
                   verifInt (show birthDay) <*>
                   verifString genre <*>
                   verifDeEmail email 
-- IAM se charge de verifier en profondeur l'email, EFA verifie juste si c'est une chaine non vide

-- fonction qui cree une fiche

createFiche :: IdFiche -> [IdAnalyse] -> Prescripteur  -> InfoPatient -> IO Fiche 
createFiche i ys p info = do
    someDate <- getCurrentTime
    return $ createHelper i ys p someDate info someDate


createHelper :: IdFiche -> [IdAnalyse] -> Prescripteur -> Date -> InfoPatient -> Date ->  Fiche
createHelper _ [] _ _ _ _ = error "la liste des identifiants des fiches ne doit pas etre vide"
createHelper someId xs prescripteur date patientInfo updateDate = 
    MkFIche someId xs prescripteur date patientInfo updateDate
    




