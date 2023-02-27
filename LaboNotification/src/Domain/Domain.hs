module Domain.Domain 
  (
    sendMail{-,
    nomExpediteur,
    emailExpediteur-}
  )where

--import qualified Data.ByteString.Char8 as B
import qualified Data.Text as T
import qualified Data.Text.Lazy as TT
import Network.Mail.Mime
import Infra.GmailSMTPConnect

notificationDomainAddress :: Address
notificationDomainAddress = Address (Just $ T.pack "SOFT INNOV ++") (T.pack "softinovplus@gmail.com")
nomExpediteur :: String
nomExpediteur = "SOFT INNOV ++"

emailExpediteur :: String
emailExpediteur = "softinovplus@gmail.com"

sendMail :: String -> String -> T.Text -> TT.Text -> IO Bool
sendMail nomdestinataire emaildestinataire sujet plaintext  = do
  --let mail = Mail notificationDomainAddress (fmap (\destinataire -> Address Nothing (T.pack destinataire)) destinataires)  [] [] [(B.pack "subject",T.pack sujet)] [[htmlPart htmltext], [plainPart plaintext], []] {-(fmap (\s -> Part (T.pack "stream") None DefaultDisposition [(B.pack "Content-Type",T.pack "stream")] (PartContent s)) attacheds)-}
  --print mail
  --sendEmail mail
  sendEmail nomdestinataire emaildestinataire  nomExpediteur emailExpediteur sujet plaintext
  --acceptPayload $ MkSimpleMail  emaildestinataire nomdestinataire nomExpediteur emailExpediteur sujet plaintext
  

