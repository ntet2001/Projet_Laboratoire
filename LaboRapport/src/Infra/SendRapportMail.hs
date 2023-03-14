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
import qualified Data.Text as T
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString as B

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

sendEmailRepport :: String -> SimpleMail -> IO ()
sendEmailRepport chemin simplemail = do
    let a = partBS (T.pack "data")  ( B.pack $ BL.unpack (encode simplemail)) 
        b = partFileSource (T.pack "fichier") chemin
        request = NT.setRequestBodyJSON simplemail "POST http://localhost:8083/report"
    print $ encode simplemail
    request1 <- formDataBody [a,b] request
    response <- NT.httpJSON request1  :: IO (Response Value)    
    print (NT.getResponseBody response)