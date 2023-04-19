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
import Network.AMQP
import qualified Data.ByteString.Lazy.Char8 as BL
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

-- cette fonction doit contenir le lien pour access au resultat par un client 
sendEmailCode :: String -> String -> String -> IO()
sendEmailCode code email nom = do 
    -- open the network connection
    conn <- openConnection "127.0.0.1" "/" "guest" "guest"
    chan <- openChannel conn
    -- here i create the mail to send true the queue
    let simpleMail = MkSimpleMail email nom "Code du patient" (code ++ " est votre code de connexion ") "<h1>Code de Connexion App Labo</h1>"
        encodedMail = encode simpleMail

    -- declare a queue, exchange and binding
    declareQueue chan newQueue {queueName = "myQueueCode"} -- create a queue and is parameters

-- create an exchange and is parameters
    declareExchange chan newExchange {exchangeName = "myExchangeCode", exchangeType = "direct"}
    bindQueue chan "myQueueCode" "myExchangeCode" "myKeyCode"

    -- publish a message to our new exchange
    publishMsg chan "myExchangeCode" "myKeyCode" newMsg {msgBody = encodedMail,msgDeliveryMode = Just Persistent} -- mykey is the routing key

    --closeConnection conn  --here i close the connection
    putStrLn "connection closed"


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




        
