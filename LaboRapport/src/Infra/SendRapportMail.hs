{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Infra.SendRapportMail where

import Network.HTTP.Conduit
import qualified Network.HTTP.Simple as NT
import Network.HTTP.Client.MultipartFormData
import GHC.Generics (Generic)
import Data.Aeson
import Data.Text.Encoding as TE
import Control.Monad
import Data.Maybe (Maybe(Nothing))

data SimpleMail = MkSimpleMail{
    emailDestinataire      :: String,
    nomDestinataire        :: String,
    subject                :: String,
    plainText              :: String,
    htmlText              :: String
}deriving Generic
instance ToJSON SimpleMail

-- sendFicheRapport :: Fiche -> IO()
-- sendFicheRapport fiche = do 
--     let request = NT.setRequestBodyJSON fiche "POST http://localhost:8082/rapports"
--     response <- NT.httpJSON request :: IO (NT.Response Value)
--     print $ NT.getResponseBody response

sendEmailRepport :: String -> SimpleMail -> IO()
sendEmailRepport cheminFichier simpleMail = do 
    let request = setRequestBodyJSON simpleMail "POST http://localhost:8083/report"
    request1 <- formDataBody (Part "simplemail" Nothing (Just "multipart/form-data") simpleMail ) [ 
        partBS "title" (encode simpleMail)
                       ,partFileSource cheminFichier
                        ]
    --response <- httpJSON request :: IO (Response Value)
    withSocketsDo $ withManager $ \m -> do
     --Response{responseBody=cat} <- flip httpLbs m $ fromJust $ parseUrl "http://random-cat-photo.net/cat.jpg"
     flip NT.httpLbs m =<<
         formDataBody [partBS "title" (encode simpleMail)
                       ,partFileSource cheminFichier
                        ]
            $ fromJust $ parseUrl "http://localhost:8083/report"
    print $ getResponseBody response