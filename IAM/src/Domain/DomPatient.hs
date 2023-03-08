{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Domain.DomPatient where 

import App.AppPatient 
import App.CommonVerification
import Infra.SavePatient
import Common.SimpleType
import Text.ParserCombinators.Parsec
import Data.Aeson 
import Network.HTTP.Simple
import GHC.Generics (Generic)

data SimpleMail = MkSimpleMail
  {
    emailDestinataire      :: String,
    nomDestinataire        :: String,
    subject                :: String,
    plainText              :: String,
    htmlText              :: String
  }deriving Generic
instance ToJSON SimpleMail

sendEmailCode :: String -> String -> String -> IO()
sendEmailCode code email nom = do 
    let simpleMail = MkSimpleMail email nom "Code du patient" (code ++ " est votre code de connexion ") "<h1>Code de Connexion App Labo</h1>" 
        request = setRequestBodyJSON simpleMail "POST http://localhost:8083/code"
    response <- httpJSON request :: IO (Response Value)
    print $ getResponseBody response


-- function to create patient 
createPatient :: NomPatient -> PrenomPatient -> String -> String  -> IO Int
createPatient x y k j = do 
    code <- genCode
    let var = createHelper x y k j code 
    case var of 
        Right someStuff -> do
            savePatient someStuff
            --envoyer le code au patient
            sendEmailCode (show code) k (x ++" "++ y)
            return code
        Left erreur -> fail ""

-- function helper to create patient
createHelper :: NomPatient -> PrenomPatient -> String -> String -> Int -> Either ParseError Patient 
createHelper nom prenom email tof val = do  
    MkPatient <$> verificationNom nom
              <*> verificationNom prenom
              <*> verificationEmail email
              <*> verificationPhoto tof 
              <*> verifCode val
              <*> verificationStatut "Aucun"




        
