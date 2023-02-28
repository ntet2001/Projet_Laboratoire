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
import Domain.Domain
import Control.Monad.IO.Class (liftIO)

data SimpleMail = MkSimpleMail
  {
    emailDestinataire      :: String,
    nomDestinataire        :: String,
    subject                :: String,
    plainText              :: String
  }
$(deriveJSON defaultOptions ''SimpleMail)

type API = ReqBody '[JSON] SimpleMail :> Post '[JSON] Bool

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = forwardToSendEmail

forwardToSendEmail :: SimpleMail -> Handler Bool
forwardToSendEmail simplemail = do 
  result <- liftIO $ sendMail (nomDestinataire simplemail) (emailDestinataire simplemail) (T.pack $ subject simplemail) (TT.pack $ plainText simplemail) 
  return result