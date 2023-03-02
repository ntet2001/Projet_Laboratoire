{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module App.Lib
    ( startApp
    , app
    ) where

import qualified Data.Text.Lazy as TT
import qualified Data.Text as T
import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
-------------------------------------------------------------------------------------
import Control.Monad
import Control.Monad.IO.Class
import Data.Text.Encoding (encodeUtf8)
import Network.HTTP.Client.MultipartFormData
import Servant.Multipart
import qualified Data.ByteString.Lazy as LBS
-------------------------------------------------------------------------------------
import Domain.Domain
import Control.Monad.IO.Class (liftIO)

import           qualified  Data.ByteString.Lazy.Internal as B8 


data SimpleMail = MkSimpleMail
  {
    emailDestinataire      :: String,
    nomDestinataire        :: String,
    subject                :: String,
    plainText              :: String,
    htmlText              :: String
  }
$(deriveJSON defaultOptions ''SimpleMail)

type API = MultipartForm Mem (MultipartData Mem) :> Post '[JSON] Bool
  {-ReqBody '[JSON] SimpleMail :> Post '[JSON] Bool
  :<|> "multipart" :> MultipartForm Mem (MultipartData Mem) :> Post '[JSON] Bool-}

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
{-server = forwardToSendEmail
  :<|>  handleEmailData -}
server = handleEmailData 
  
forwardToSendEmail :: SimpleMail -> Handler Bool
forwardToSendEmail simplemail = do 
  result <- liftIO $ sendMail (nomDestinataire simplemail) (emailDestinataire simplemail) (T.pack $ subject simplemail) (TT.pack $ plainText simplemail) (TT.pack $ htmlText simplemail) (B8.packChars "Data") ""
  return result
  
handleEmailData :: MultipartData Mem -> Handler Bool
handleEmailData multipartDataInMe = do
  let jsonDataKeyVal = inputs multipartDataInMe
      jsonData = iValue $ head jsonDataKeyVal
  --liftIO $ putStrLn $ T.unpack jsonData
  
  let fichier = head $ files multipartDataInMe
      contenufichier  = fdPayload fichier
      nomFichier = fdFileName fichier
  --liftIO $ LBS.putStr contenufichier
  
  let simplemailMaybe = decode $ B8.packChars $ T.unpack jsonData
  case simplemailMaybe of
    Just simplemail -> do 
      result <- liftIO $ sendMail (nomDestinataire simplemail) (emailDestinataire simplemail) (T.pack $ subject simplemail) (TT.pack $ plainText simplemail) (TT.pack $ htmlText simplemail) contenufichier  (T.unpack nomFichier)
      return result
    Nothing -> return False
  
  {-liftIO $ do
      putStrLn "Inputs:"
      forM_ (inputs multipartDataInMe) $ \input -> do
        putStrLn $ "  " ++ show (iName input)
              ++ " -> " ++ show (iValue input)
  
      forM_ (files multipartDataInMe) $ \file -> do
        let content = fdPayload file
        putStrLn $ "Content of " ++ show (fdFileName file)
        LBS.putStr content-}
  
  
  
  
  