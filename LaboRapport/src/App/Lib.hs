{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
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
import Data.Time (getCurrentTime)
import qualified App.Resultat as R

-- Format a respecter pour l'update de Rapport afin d'y metttre les resultats
data Repport = MkRepport {
    idRepport :: Int,
    contenus :: [IdResult]
}deriving (Show,Read,Eq,Generic)
$(deriveJSON defaultOptions ''Repport)

type API = "rapports" :> Get '[JSON] [Rapport]
  :<|> "rapports" :> Capture "idRapport" Int :> Get '[JSON] Rapport
  :<|> "rapports" :> ReqBody '[JSON] Fiche :> Post '[JSON] String 
  :<|> "rapports" :> ReqBody '[JSON] Repport :> Put '[JSON] String
  :<|> "rapports" :> Capture "idRapport" Int :> Delete '[JSON] String
  :<|> "results" :> Capture "idFiche" Int :> Get '[JSON] [Resultat] 
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
server = readRapports
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
  liftIO $ createNewRepport fiche
  --return something

{-========= function to modified a Repport ==========-}
modifiedRapports :: Repport -> Handler String 
modifiedRapports rapport  = do
  liftIO $ updateRapport (idRepport rapport) (contenus rapport)
  

{-====== function to delete a Repport =======-}
deleteRapports :: Int -> Handler String 
deleteRapports identifiant = do
  liftIO $ deleteRapport identifiant


{-========= function to read a list of results =======-}
readResults :: Int -> Handler [Resultat]
readResults idfiche =  do 
  result <- liftIO $ readResultFiche idfiche
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
registerResults resultat = do 
  sortie <- liftIO $ R.saveResult (idAnals resultat) (interpretations resultat) (conclusions resultat) (ficheId resultat) (prescripteurs resultat) (numDossiers resultat) (lineresults resultat) (nomLaborantins resultat) 
  liftIO $ print sortie
  return sortie


{-======== function to modified a result =====-}
modifiedResults :: Results -> Int -> Handler String
modifiedResults resultat identifiant = do 
  liftIO $ updateResult identifiant (idAnals resultat) (interpretations resultat) (conclusions resultat) (ficheId resultat) (prelevements resultat) (prescripteurs resultat) (numDossiers resultat) 
      (fmap read (lineresults resultat) :: [LineResult]) (nomLaborantins resultat)
  return "le result a ete modifie."

{-====== function to delete a result =======-}
deleteResults :: Int -> Handler String 
deleteResults identifiant = do 
  liftIO $ deleteResult identifiant
