module Domain.Domain 
  (
    sendMail
  )where

import qualified Data.Text as T
import qualified Data.Text.Lazy as TT
import Infra.GmailSMTPConnect
import           qualified  Data.ByteString.Lazy.Internal as B8 


--notificationDomainAddress :: Address
--notificationDomainAddress = Address (Just $ T.pack "SOFT INNOV ++") (T.pack "softinovplus@gmail.com")
nomExpediteur :: String
nomExpediteur = "SOFT INNOV ++"

emailExpediteur :: String
emailExpediteur = "softinovplus@gmail.com"

sendMail :: String -> String -> T.Text -> TT.Text ->  TT.Text -> B8.ByteString -> String -> IO Bool
sendMail nomdestinataire emaildestinataire sujet plaintext htmltext filecontent filename = do
  sendEmail nomdestinataire emaildestinataire  nomExpediteur emailExpediteur sujet plaintext htmltext filecontent filename
  

