{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}

module Infra.GmailSMTPConnect
  (
    sendEmail,
  ) where


import Network.Mail.Mime
import Network.Mail.SMTP

import System.IO.Error

-- Configuration
gmailApiUsername :: String
gmailApiUsername = "manyamaigor2001@gmail.com"

gmailApiPassword :: String
gmailApiPassword = "qfst biup aivp lnxs"

hostName :: String
hostName = "smtp.gmail.com"

-- Sending E-Mail
sendEmail :: Mail -> IO Bool
sendEmail  lemail = do   
  catchIOError (sendMailWithLoginTLS hostName  gmailApiUsername gmailApiPassword lemail) errorHandler 
  return True
  
errorHandler :: IOError -> IO ()

errorHandler e | isDoesNotExistError e = putStrLn "The file doesn't exist!"
               | isFullError e = putStrLn "Please try to free space and retry"
               | isIllegalOperation e = putStrLn "Please verify your data input"
               | otherwise = ioError e
-- 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

