{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module App.Lib
    ( startApp
    , app
    ) where

import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Common.SimpleTypes
import Data.Time
import GHC.Generics
import Data.Char
import Control.Monad.IO.Class
import Infra.DeleteRapport
import Infra.DeleteResult
import Infra.ReadRapport
import Infra.ReadResult
import Infra.SaveRapport
import Infra.SaveResult
import Infra.UpdateRapport
import Infra.UpdateResult
import App.VerificationRapport

data Fiche = MkFiche
  { 
    idFiche :: Int,
    analyses :: [String],
    prescripteur :: String,
    date :: UTCTime,
    infoPatient :: InfoPatient,
    dateUpdate :: UTCTime
  } deriving (Eq, Show)
$(deriveJSON defaultOptions ''Fiche)

data Results = MkResults
  { idAnals :: Int
  , interpretations :: String
  , conclusions :: String
  , infoPatients :: InfoPatient
  , prelevements :: UTCTime 
  , prescripteurs :: String
  , numDossiers :: Int 
  , lineresults :: [String]
  , nomLaborantins :: String
  } deriving (Eq, Show)
$(deriveJSON defaultOptions ''Results)

type API = "rapports" :> Get '[JSON] [Rapport]
  :<|> "rapports" :> Capture "idRapport" Int :> Get '[JSON] Rapport
  :<|> "rapports" :> ReqBody '[JSON] Fiche :> Post '[JSON] String 
  :<|> "rapports" :> ReqBody '[JSON] Fiche :> Capture "idRapport" Int :> Put '[JSON] String
  :<|> "rapports" :> Capture "idRapport" Int :> Delete '[JSON] String
  :<|> "results" :> Get '[JSON] [Resultat]
  :<|> "results" :> Capture "idResult" Int :> Get '[JSON] Resultat
  :<|> "results" :> ReqBody '[JSON] Results :> Post '[JSON] String 
  :<|> "results" :> ReqBody '[JSON] Results :> Capture "idResult" Int :> Put '[JSON] String 
  :<|> "results" :> Capture "idResult" Int :> Delete '[JSON] String


startApp :: IO ()
startApp = run 8082 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = return readRapports
  :<|> readARapports
  :<|> registerRapports
  :<|> modifiedRapports
  :<|> deleteRapports
  :<|> readResults
  :<|> readAResults
  :<|> registerResults
  :<|> modifiedResults
  :<|> deleteResults

{-========= function to read a list of Repports ==========-}
readRapports :: Handler [Rapport]
readRapports = do 
  result <- liftIO readRapport
  liftIO $ print result 
  return result

{-========= function to read a Repport ==========-}
readARapports :: Int -> Handler Rapport
readARapports identifiant = do
  result <- liftIO $ readARapport identifiant
  liftIO $ print result 
  return result 


{-========= function to register an analyse ==========-}
registerRapports :: Fiche -> Handler String
registerRapports fiche = do
  liftIO $ createNewRepport (idFile fiche)

{-========= function to modified a Repport ==========-}
modifiedRapports :: Repport -> Int -> Handler String 
modifiedRapports rapport idRapport = do
  liftIO $ updateRapport idRapport (content rapport)

{-====== function to delete a Repport =======-}
deleteRapports :: Int -> Handler String 
deleteRapports identifiant = do
  liftIO $ deleteRapport identifiant


{-========= function to read a list of results =======-}
readResults :: Handler [Resultat]
readResults =  do 
  result <- liftIO readResult
  liftIO $ print result 
  return result  

{-========= function to read a result ========-}
readAResults :: Int -> Handler Resultat 
readAResults identifiant = do
  result <- liftIO $ readAResult identifiant
  liftIO $ print result 
  return result 

{-======== function to register a result ======-}
registerResults :: Results -> Handler String 
registerResults resultat = undefined


{-======== function to modified a result =====-}
modifiedResults :: Results -> Int -> Handler String
modifiedResults resultat identifiant = do 
  liftIO $ updateResult identifiant (idAnals resultat) (interpretations resultat) (conclusions resultat) (infoPatients resultat) (prelevements resultat) (prescripteurs resultat) (numDossiers resultat) (lineresults resultat) (nomLaborantins resultat)

{-====== function to delete a result =======-}
deleteResults :: Int -> Handler String 
deleteResults identifiant = do 
  liftIO $ deleteResult identifiant
