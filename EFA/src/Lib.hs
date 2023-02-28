{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Lib where

import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Common.SimpleTypes
import Infra.SaveAnalyse
import Common.SimpleTypes
import Domain.CreateAnalyse
import App.CommonVerification
-- import Data.Aeson (ToJSON, FromJSON)
import Database.MySQL.Simple
import Database.MySQL.Simple.Types
import Control.Monad.IO.Class (liftIO)
import Infra.DeleteAnalyse
import Infra.ReadAnalyse
import Infra.SaveAnalyse
import Infra.UpdateAnalyse
import Common.SimpleTypes


$(deriveJSON defaultOptions ''ValUsuel)

$(deriveJSON defaultOptions ''Categorie)

$(deriveJSON defaultOptions ''Analyse)

type API = "analyses" :> Get '[JSON] [Analyse]
    :<|> "insert" :> "analyse" :>  ReqBody '[JSON] Analyse :> Post '[JSON] String
    :<|> "modify" :> "analyse" :>  ReqBody '[JSON] Analyse :> Put '[JSON] String
    :<|> "delete" :> "analyse" :> Capture "idAnalyse" String :> DeleteNoContent

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = readAnalsH
    :<|> createAnalH
    :<|> updateAnalH
    :<|> deleteAnalH

readAnalsH :: Handler [Analyse]
readAnalsH = do
    val <- liftIO $ readAnals
    return val

updateAnalH :: Analyse -> Handler String
updateAnalH a = do
    liftIO $ updateAnal a
    return "modification reussie"  

deleteAnalH :: String -> Handler NoContent
deleteAnalH ida  = do
    liftIO $ deleteAnal ida
    return $ error "erreur"

createAnalH :: Analyse -> Handler String
createAnalH a = do 
    liftIO $ createAnal a
    return "insertion reussie"


    

