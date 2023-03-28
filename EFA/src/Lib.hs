{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module Lib
    ( startApp
    ,app
    ) where

import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import GHC.Generics
import Data.Char
import Control.Monad.IO.Class
import Common.SimpleTypes
import App.Fonction
import qualified App.Funzione as F
import Infra.SaveAnalyse
import Infra.UpdateFiche
import Infra.UpdateAnalyse
import Infra.DeleteFiche
import Infra.DeleteAnalyse
import Infra.ReadFiche 
import Infra.ReadAnalyse 
import App.AppDeleteFiche

data FicheLib = MkFIcheLib {
  idFicheLib :: Int,
  analysesLib :: [String],
  prescripteurLib :: String,
  nomLib :: String,
  prenomLib :: String,
  dateBirthPatient :: Int,
  genreLib :: String,
  emailLib :: String
} deriving (Show, Eq, Read, Generic)
$(deriveJSON defaultOptions ''FicheLib)

type API = "Analyses" :> Get '[JSON] [Analyse]
    :<|> "Analyse" :> Capture "idAnalyse" String :> Get '[JSON] Analyse 
    :<|> "Analyse" :> ReqBody '[JSON] Analyse2 :> Post '[JSON] String
    :<|> "Analyse" :> ReqBody '[JSON] Analyse :> Put '[JSON] String
    :<|> "Analyse" :> ReqBody '[JSON] Analyse :> Delete '[JSON] String
    :<|> "Fiches" :> Get '[JSON] [Fiche]
    :<|> "Fiche" :> Capture "idFiche" Int :> Get '[JSON] Fiche
    :<|> "Fiche" :> ReqBody '[JSON] FicheLib :> Post '[JSON] Fiche
    :<|> "Fiche" :> ReqBody '[JSON] FicheLib :> Put '[JSON] String
    :<|> "Fiche" :> Capture "idFiche" Int :> Delete '[JSON] String

startApp :: IO ()
startApp = run 8081 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = readanalyses
  :<|> readanalyse
  :<|> registeranalyse
  :<|> modifiedanalyse
  :<|> deleteanalyse
  :<|> readfiches
  :<|> readfiche
  :<|> registerfiche 
  :<|> modifiedfiche
  :<|> deletefiche

{-========= function to read a list of analyses ==========-}
readanalyses :: Handler [Analyse]
readanalyses = do 
  result <- liftIO readAnalyse
  liftIO $ print result 
  return result 

{-========= function to read an analyse ==========-}
readanalyse :: String -> Handler Analyse
readanalyse identifiant = do
  result <- liftIO $ readaAnalyse identifiant
  liftIO $ print result 
  return result 


{-========= function to register an analyse ==========-}
registeranalyse :: Analyse2 -> Handler String
registeranalyse analyse = do
  result <- liftIO $ save (nomAnalyse2 analyse) (show $ valUsuel2 analyse) (show $ categorie2 analyse)
  return "analyse a ete enregistré" 

{-========= function to modified an analyse ==========-}
modifiedanalyse :: Analyse -> Handler String 
modifiedanalyse analyse = do
  liftIO $ update (nomAnalyse analyse) (show $ valUsuel analyse) (show $ categorie analyse)  
  liftIO $ updateAnalyse analyse
  return "successful"

{-====== function to delete an analyse =======-}
deleteanalyse :: Analyse -> Handler String 
deleteanalyse anlyse = do
  liftIO $ deleteAnalyse ( idAnalyse anlyse)
  return "Suppression reussie"


{-========= function to read a list of fiches =======-}
readfiches :: Handler [Fiche]
readfiches =  do 
  result <- liftIO readFiche
  liftIO $ print result 
  return result  

{-========= function to read a fiche ========-}
readfiche :: Int -> Handler Fiche 
readfiche identifiant = do
  result <- liftIO $ readAFiche identifiant
  liftIO $ print result 
  return result 

{-======== function to register a fiche ======-}
registerfiche :: FicheLib -> Handler Fiche 
registerfiche fiche = do
  liftIO $ F.save' (idFicheLib fiche) (analysesLib fiche) (prescripteurLib fiche) (nomLib fiche) (prenomLib fiche) (dateBirthPatient fiche) (genreLib fiche) (emailLib fiche)


{-======== function to update a fiche =====-}
modifiedfiche :: FicheLib -> Handler String
modifiedfiche fiche = do 
  result <- liftIO $ F.newUpdateFiche (idFicheLib fiche) (analysesLib fiche) (prescripteurLib fiche) (MkPatient (nomLib fiche) (prenomLib fiche) (dateBirthPatient fiche) (genreLib fiche) (emailLib fiche))
  return "successful"

{-====== function to delete a fiche =======-}
deletefiche :: Int -> Handler String 
deletefiche idfiche = do 
  liftIO $ appDeleteFiche idfiche
