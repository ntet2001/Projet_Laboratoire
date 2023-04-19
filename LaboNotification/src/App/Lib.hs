{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module App.Lib where

import qualified Data.Text.Lazy as TT
import qualified Data.Text as T
import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Network.AMQP
import qualified Data.ByteString.Lazy.Char8 as BL
-------------------------------------------------------------------------------------
import Control.Monad.IO.Class
import Servant.Multipart
-------------------------------------------------------------------------------------
import Domain.Domain

import qualified  Data.ByteString.Lazy.Internal as B8 


data SimpleMail = MkSimpleMail
  {
    emailDestinataire      :: String,
    nomDestinataire        :: String,
    subject                :: String,
    plainText              :: String,
    htmlText              :: String
  } deriving (Show) 
$(deriveJSON defaultOptions ''SimpleMail)
-- 

myCallback :: (Message,Envelope) -> IO ()
myCallback (msg, env) = do
    let messageSend = msgBody msg 
        messageSendConvert = decode messageSend :: Maybe SimpleMail  -- here i convert the message 

    print messageSendConvert
    -- here i call the function to send mail
    handleEmailDataCode messageSendConvert
    print "2222222222222222222222"
-- acknowledge receiving the message
    ackEnv env


mqconnectionR :: IO()
mqconnectionR = do

-- open the network connection
  conn <- openConnection "127.0.0.1" (T.pack "/") (T.pack "guest") (T.pack "guest")
  chan <- openChannel conn

-- subscribe to the queue
  consumeMsgs chan (T.pack "myQueueCode") Ack myCallback

  print "11111111"
  getLine -- wait for keypress
  closeConnection conn
  putStrLn "connection closed"
  
handleEmailDataCode :: Maybe SimpleMail -> IO Bool
handleEmailDataCode simplemail = do 
  case simplemail of
    Just mail -> do 
      sendMailCode (nomDestinataire mail) (emailDestinataire mail) (T.pack $ subject mail) (TT.pack $ plainText mail) (TT.pack $ htmlText mail)
    Nothing -> return False 
    
handleEmailDataReport :: MultipartData Mem -> Handler Bool
handleEmailDataReport multipartDataInMe = do
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
      result <- liftIO $ sendMailReport (nomDestinataire simplemail) (emailDestinataire simplemail) (T.pack $ subject simplemail) (TT.pack $ plainText simplemail) (TT.pack $ htmlText simplemail) contenufichier  (T.unpack nomFichier)
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
  
  
  
  
  