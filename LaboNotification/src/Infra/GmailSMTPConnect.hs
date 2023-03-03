{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}

module Infra.GmailSMTPConnect
  (
    connectToGmailSMTPServer,
    sendEmail,
    acceptPayload,
    SimpleMail (..)
  ) where

import           Network.HaskellNet.IMAP.SSL
import           Network.HaskellNet.SMTP.SSL as HaskellNetSMTP

import           Network.HaskellNet.Auth
import qualified Data.Text as T
--import Data.ByteString.Lazy.Internal
import Network.Mail.Mime
import Network.Mail.SMTP
import qualified Data.Text.Lazy as TT
import           Control.Concurrent      (forkIO, threadDelay)
import           Control.Concurrent.MVar (MVar, newMVar, putMVar, takeMVar)
import           Control.Monad           (forever)
import           Data.Aeson              (FromJSON, ToJSON)
import           GHC.Generics            (Generic)
import           System.Hworker
import           qualified  Data.ByteString.Lazy.Internal as B8
import           Data.ByteString.Lazy
import           Network.Socket
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
    res <- sendEmail nd ed ne ee sujet pt "" "" ""
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
connectToGmailSMTPServer :: HaskellNetSMTP.SMTPConnection -> IO Bool
connectToGmailSMTPServer smtpConnection = HaskellNetSMTP.authenticate Network.HaskellNet.Auth.LOGIN gmailApiUsername gmailApiPassword smtpConnection

-- Sending E-Mail
sendEmail :: String -> String -> String -> String -> T.Text -> TT.Text ->  TT.Text -> B8.ByteString -> String -> IO Bool
sendEmail  nomdestinataire emaildestinataire nomexpediteur emailexpediteur sujet plaintext htmltext datastream filename = doSMTPSTARTTLS hostName (\c -> do
    authSucceed <- connectToGmailSMTPServer c
    if authSucceed
      then do
        --datastream <- B8.readFile filename
        let   notificationDomainAddress = Address (Just $ T.pack nomexpediteur) (T.pack emailexpediteur)
              nomdelhote = hostName
              numeroduport = 465 :: PortNumber
              lemail = Mail
                notificationDomainAddress
                [(Address (Just $ T.pack nomdestinataire) (T.pack emaildestinataire))]
                []
                []
                [("subject",  sujet)]
                [[(Part (T.pack "text/plain") QuotedPrintableText DefaultDisposition [] (PartContent $ B8.packChars $ TT.unpack plaintext))], [(Part (T.pack "text/html") QuotedPrintableText DefaultDisposition [] (NestedParts [Network.Mail.SMTP.htmlPart htmltext]){-(PartContent $ B8.packChars $ TT.unpack htmltext)-})], [(Part (T.pack "application/pdf") QuotedPrintableBinary (AttachmentDisposition $ T.pack filename) [] (PartContent datastream))] {-[textVersion, htmlVersion], [attachment1], [attachment1]-}]

        sendMailWithLoginTLS nomdelhote {-numeroduport-} gmailApiUsername gmailApiPassword lemail
        --sendPlainTextMail (Address (Just $ T.pack nomdestinataire) (T.pack emaildestinataire)) notificationDomainAddress sujet plaintext c
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




