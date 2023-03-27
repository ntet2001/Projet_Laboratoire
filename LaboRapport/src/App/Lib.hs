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
import Control.Applicative
import System.IO 
import Infra.RepportBuild
import Infra.SendRapportMail
import App.Fonction

-- Format a respecter pour l'update de Rapport afin d'y metttre les resultats
data Repport = MkRepport {
    idRepport :: Int,
    contenus :: [IdResult]
}deriving (Show,Read,Eq,Generic)
$(deriveJSON defaultOptions ''Repport)

type API = "rapports" :> Get '[JSON] [Rapport]
  :<|> "rapports" :> Capture "idRapport" Int :> Get '[JSON] Rapport
  :<|> "rapports" :> "build" :> Capture "idRapport" Int :> Get '[JSON] String
  :<|> "rapports" :> ReqBody '[JSON] Fiche :> Post '[JSON] String 
  :<|> "rapports" :> ReqBody '[JSON] Repport :> Put '[JSON] String
  :<|> "rapports" :> Capture "idRapport" Int :> Delete '[JSON] String
  :<|> "results" :> Capture "idFiche" Int :> Get '[JSON] [Resultat] 
  :<|> "results" :> Capture "idResult" Int :> Get '[JSON] Resultat
  :<|> "results" :> ReqBody '[JSON] Results :> Post '[JSON] String 
  :<|> "results" :> ReqBody '[JSON] Results :> Capture "idResult" Int :> Put '[JSON] String 
  :<|> "results" :> Capture "idResult" Int :> Delete '[JSON] String
  :<|> "Analyse" :> ReqBody '[JSON] Analyse2 :> Post '[JSON] String
  :<|> "rapports" :> "contenus" :> Capture "idRapport" Int :> Get '[JSON] [Int]
  :<|> "rapport" :> "fiche" :> ReqBody '[JSON] Fiche :> Put '[JSON] String


startApp :: IO ()
startApp = run 8082 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = readRapports
  :<|> readARapports
  :<|> buildrapport
  :<|> registerRapports
  :<|> modifiedRapports
  :<|> deleteRapports
  :<|> readResults
  :<|> readAResults
  :<|> registerResults
  :<|> modifiedResults
  :<|> deleteResults
  :<|> registeranalyse
  :<|> readARapportsContenu
  :<|> updateRapportByIdFiche

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
  
{-========= function to read a content Repport ==========-}
readARapportsContenu :: Int -> Handler [IdResult]
readARapportsContenu identifiant = do
  result <- liftIO $ readARapport identifiant
  return $ contenu result

{-======== function to get all the Repports for a patient by a given name ========-}
readRapportName :: String -> [Rapport]
readRapportName name = undefined --igor je suis bloque au niveau de la reflexion sur l'id de fiche dans rapport.



{-======== function to read a repport and send it to a patient ======-}
buildrapport :: Int -> Handler String
buildrapport idRapport = do
  repport <- liftIO $ readARapport idRapport
  let listeResultsIO = fmap readAResult (contenu repport)
      patient = (infoPatient.fiche) repport
      ficheDansRapport = showFiche $ (infoPatient.fiche) repport
  listeResults <-  liftIO $ sequence listeResultsIO
  let listeResultsStr = ficheDansRapport ++ "\n" ++ (concat $ fmap showResultat listeResults)
  -- result <- liftIO listeResults
  chemin <- liftIO $ repportBuilding  listeResultsStr (show idRapport)
  liftIO $ sendEmailRepport chemin (MkSimpleMail (email patient) (nom patient ++ " " ++ prenom patient)  "Rapport Patient" ""  "<h1> Voici le Pdf de votre rapport </h1>")
  return chemin 


{-========= function to register an analyse ==========-}
registerRapports :: Fiche -> Handler String
registerRapports fiche = do
  liftIO $ print (show fiche)
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

{-========= function to register an analyse ==========-}
registeranalyse :: Analyse2 -> Handler String
registeranalyse analyse = do
  result <- liftIO $ save (nomAnalyse2 analyse) (show $ valUsuel2 analyse) (show $ categorie2 analyse)
  return "analyse a ete enregistré"    
  
-- function to get a report by the given id of fiche 

updateRapportByIdFiche :: Fiche -> Handler String 
updateRapportByIdFiche lafiche = do
  liftIO $ R.updateFicheIntoReport lafiche
