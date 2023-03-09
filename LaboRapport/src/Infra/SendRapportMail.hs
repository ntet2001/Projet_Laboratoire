{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Infra.SendRapportMail where

import Data.Aeson 
import Network.HTTP.Simple
import Network.HTTP.Conduit.MultipartFormData
import GHC.Generics (Generic)

data SimpleMail = MkSimpleMail{
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
        request = setRequestBodyJSON simpleMail "POST http://localhost:8083/report"
    response <- httpJSON request :: IO (Response Value)
    print $ getResponseBody response