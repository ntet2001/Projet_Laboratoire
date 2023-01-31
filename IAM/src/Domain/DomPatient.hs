{-# OPTIONS_GHC -Wno-missing-export-lists #-}
module Domain.DomPatient where 

import App.AppPatient 
import Common.SimpleType
import App.AppFile (verifEmail, verifNomEtPrenom, verifEmail, verifPhoto) 
import Text.ParserCombinators.Parsec



-- fonction pour creer un patient, le refactoring se fera avec le monad tranformer 
createPatient :: NomPatient -> PrenomPatient -> String -> String  -> IO Patient 
createPatient x y k j = do 
    code <- genCode
    let var = createHelper x y k j code 
    case var of 
        Right someStuff -> return someStuff
        Left erreur -> error $ show erreur 

-- fonction d'aide a la fonction pour creer un patient 
createHelper :: NomPatient -> PrenomPatient -> String -> String -> Int -> Either ParseError Patient 
createHelper nom prenom email tof val = do  
    MkPatient <$> verifNomEtPrenom nom
              <*> verifNomEtPrenom prenom
              <*> verifEmail email
              <*> verifPhoto tof 
              <*> verifCode val

-- verifier si un patient existe deja avant de l'enregistrer 

verifPatient :: Patient -> String -> IO (Either String Patient) 
verifPatient inputPatient nameFile = do
    contient <- readFile nameFile 
    let ligneParligne = lines contient
        convertToPatient = fmap read ligneParligne :: [Patient]
        --listInfosPatient = map infos convertToPatient :: [InfoPatient]
        var = emailOf inputPatient 
        emailOfPatient = fmap emailOf convertToPatient
        listeEmail = filter (== var)  emailOfPatient
    if null listeEmail then return $ Right inputPatient
      else return $ Left "ce patient existe deja !!"




        
