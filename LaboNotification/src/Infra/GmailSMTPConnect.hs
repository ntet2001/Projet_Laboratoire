{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}

module Infra.GmailSMTPConnect 
  (
    connectTGmailSMTPServer,
    sendEmail,
    acceptPayload,
    SimpleMail (..)
  ) where
    
import           Network.HaskellNet.IMAP.SSL
import           Network.HaskellNet.SMTP.SSL as SMTP

import           Network.HaskellNet.Auth
import qualified Data.Text as T
--import Data.ByteString.Lazy.Internal
import Network.Mail.Mime 
import qualified Data.Text.Lazy as TT
import           Control.Concurrent      (forkIO, threadDelay)
import           Control.Concurrent.MVar (MVar, newMVar, putMVar, takeMVar)
import           Control.Monad           (forever)
import           Data.Aeson              (FromJSON, ToJSON)
import           GHC.Generics            (Generic)
import           System.Hworker
--import           Domain.Domain hidden sendMail


data SimpleMail = MkSimpleMail
  {
    emailDestinataire      :: String,
    nomDestinataire        :: String,
    nomExped               :: String,
    emailExpe              :: String,
    subject                :: T.Text,
    plainText              :: TT.Text
  } deriving (Generic, Show)
  
data State = State (MVar Int)

instance ToJSON SimpleMail
instance FromJSON SimpleMail

instance Job State SimpleMail where
  job (State mvar) sm = do
    let nd = nomDestinataire sm
        ed = emailDestinataire sm
        ne = nomExped sm 
        ee = emailExpe sm
        sujet = subject sm 
        pt = plainText sm 
    res <- sendEmail nd ed ne ee sujet pt 
    if res 
      then do return Success
      else do error $ "Dying: " ++ show res
    {-do v <- takeMVar mvar
       if v == 0
          then do putMVar mvar 0
                  putStrLn "A" >> return Success
          else do putMVar mvar (v - 1)
                  error $ "Dying: " ++ show v-}

{-
  job _ PrintB = putStrLn "B" >> return Success
-}

{-
------------------------------------ ODDS-JOBS ------------------------------------

import OddJobs.Job (Job(..), ConcurrencyControl(..), Config(..), throwParsePayload, TableName)
import OddJobs.ConfigBuilder (mkConfig, withConnectionPool, defaultTimedLogger, defaultLogStr, defaultJobType)
--import OddJobs.Cli (defaultMain)


-- Note: It is not necessary to use fast-logger. You can use any logging library
-- that can give you a logging function in the IO monad.
import System.Log.FastLogger(withTimedFastLogger, LogType'(..), defaultBufSize)
import System.Log.FastLogger.Date (newTimeCache, simpleTimeFormat)

import Data.Text (Text)
import Data.Aeson as Aeson
import GHC.Generics

-- This example is using these functions to introduce an artificial delay of a
-- few seconds in one of the jobs. Otherwise it is not really needed.
import OddJobs.Types (delaySeconds, Seconds(..))
import Database.PostgreSQL.Simple

-}


---------------------------------------------------------------------------


-- Configuration
gmailApiUsername :: Network.HaskellNet.Auth.UserName
gmailApiUsername = "softinovplus@gmail.com"
--gmailApiUsernameAddress :: Address
-- = Address Nothing (T.pack "softinovplus@gmail.com")

gmailApiPassword :: Network.HaskellNet.Auth.Password
gmailApiPassword = "ygdp mfmh urcb bihh"

hostName :: String
hostName = "smtp.gmail.com"

{-
This function is to connect to Gmail SMTP srver.
The parameters pass to this function is comming from the gmail account api configuration where you have to enable 
2 step Verification and generate the app password 
(see the following link: https://medium.com/graymatrix/using-gmail-smtp-server-to-send-email-in-laravel-91c0800f9662) 
-}
connectTGmailSMTPServer :: SMTPConnection -> IO Bool
connectTGmailSMTPServer smtpConnection = SMTP.authenticate LOGIN gmailApiUsername gmailApiPassword smtpConnection

-- Sending E-Mail
sendEmail :: String -> String -> String -> String -> T.Text -> TT.Text  -> IO Bool
sendEmail  nomdestinataire emaildestinataire nomexpediteur emailexpediteur sujet plaintext = doSMTPSTARTTLS hostName (\c -> do
    authSucceed <- connectTGmailSMTPServer c
    if authSucceed
      then do  
        let   notificationDomainAddress = Address (Just $ T.pack nomexpediteur) (T.pack emailexpediteur)
        sendPlainTextMail (Address (Just $ T.pack nomdestinataire) (T.pack emaildestinataire)) notificationDomainAddress sujet plaintext c
        return True
      else return False
  ) 
  
acceptPayload :: SimpleMail -> IO Bool
acceptPayload sm = do
  mvar <- newMVar 3
  hworker <- System.Hworker.create "SimpleMail" (State mvar)
  forkIO (worker hworker)
  forkIO (monitor hworker)
  bybool <- queue hworker sm
  return True

--dBconnectionInfo :: ConnectInfo
--dBconnectionInfo = ConnectInfo "localhost" 5432 "douki" "Ange1308!!" "labonotification"
--
--emailNotificationQueueTable :: TableName
--emailNotificationQueueTable = "jobs_emails"

  
  

