{-# OPTIONS_GHC -Wno-missing-export-lists #-}
module Domain.DomPatient where 

import App.AppPatient 
import App.CommonVerification
import Infra.SavePatient
import Common.SimpleType
import Text.ParserCombinators.Parsec



-- function to create patient 
createPatient :: NomPatient -> PrenomPatient -> String -> String  -> IO ()
createPatient x y k j = do 
    code <- genCode
    let var = createHelper x y k j code 
    case var of 
        Right someStuff -> do
            savePatient someStuff
            putStrLn "Patient enregistrer"
        Left erreur -> putStrLn $ show erreur 

-- function helper to create patient
createHelper :: NomPatient -> PrenomPatient -> String -> String -> Int -> Either ParseError Patient 
createHelper nom prenom email tof val = do  
    MkPatient <$> verificationNom nom
              <*> verificationNom prenom
              <*> verificationEmail email
              <*> verificationPhoto tof 
              <*> verifCode val
              <*> verificationStatut "Aucun"




        
