{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Lib
    ( startApp
    , app
    ) where

import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Language()
import Common.SimpleType
import Infra.ReadOperateur
import Infra.ReadPatient 
import Infra.DeleteOperateur
import Infra.DeletePatient
import Infra.UpdateOperateur
import Infra.UpdatePatient
import Infra.SaveOperateur
import Infra.SavePatient
import Domain.DomPatient
import Domain.CreationOperateur
import Domain.ConnexionOperateur
import Domain.DeconnexionOperateur
import Domain.ConnexionPatient
import Domain.DeconnexionPatient
import Control.Monad.IO.Class
import qualified Data.Text as T

type API = "operators" :> Get '[JSON] [Operateur] 
    :<|> "patients" :> Get '[JSON] [Patient] 
    :<|> "operators" :> Capture "matricule" String :> Get '[JSON] Operateur 
    :<|> "patients" :> Capture "code" Int :> Get '[JSON] Patient
    :<|> "operators" :> Capture "matricule" String :> DeleteNoContent
    :<|> "patients" :> Capture "code" Int :> DeleteNoContent
    :<|> "operators" :> ReqBody '[JSON] Operateur :> Put '[JSON] Operateur
    :<|> "patients" :> ReqBody '[JSON] Patient :> Put '[JSON] Patient
    :<|> "operators" :> Capture "nom" String :> Capture "prenom" String :> Capture "matricule" String :> Capture "email" String :> Capture "password" String :> Capture "photo" String :> Post '[JSON] String
    :<|> "patients" :> Capture "nom" String :> Capture "prenom" String :> Capture "email" String :> Capture "photo" String :> Capture "code" Int :> Post '[JSON] String
    :<|> "connexionoperators" :> ReqBody '[JSON] Operateur :> Post '[JSON] Operateur
    :<|> "connexionpatients" :> ReqBody '[JSON] Patient :> Post '[JSON] Patient
    :<|> "deconnexionoperators" :> ReqBody '[JSON] Operateur :> Post '[JSON] Operateur
    :<|> "deconnexionpatients" :> ReqBody '[JSON] Patient :> Post '[JSON] Patient

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = operators 
    :<|> patients 
    :<|> operator 
    :<|> patient 
    :<|> deleteoperator 
    :<|> deletepatient
    :<|> updateoperator
    :<|> updatepatient
    :<|> createoperator
    :<|> createpatient
    :<|> connectoperateur
    :<|> connectpatient
    :<|> deconnectoperateur
    :<|> deconnectpatient

{-========= LIST OF OPERATORS =======-}
operators ::  Handler [Operateur]
operators = do 
    var <- (liftIO readOperator)
    liftIO $ print var
    return var

{-========= TAKE AN OPERATOR =======-}
operator :: String -> Handler Operateur
operator matricule = do 
    var <- (liftIO $ readAOperator matricule)
    return $ head var

{-========= DELETE AN OPERATOR =======-}
deleteoperator :: String -> Handler NoContent
deleteoperator matricule = do 
    var <- (liftIO $ deleteOperator matricule)
    return $ error ""

{-========= UPDATE AN OPERATOR =======-}
updateoperator :: Operateur -> Handler Operateur
updateoperator op = do 
    let nom = nomOp op 
        prenom = prenomOp op
        mat = matricule op 
        mail = email op
        pass = passwordOp op
        image = photo op 
        statut = statutOp op 
    var <- (liftIO $ (updateOperator nom prenom mat mail pass image statut))
    return op

{-======= CREATE AN OPERATOR ========-}
createoperator :: NomOp -> PrenomOp -> Matricule -> String -> PasswordOp -> String -> Handler String
createoperator nom prenom matricule email password photo = do 
    let operateur = createOperator nom prenom matricule email password photo
    case operateur of
        Right a -> do 
            liftIO $ print a
            sav <- liftIO $ saveOperator a
            return "saved"
        Left b -> do 
            sav <- liftIO $ putStrLn "Register Failed"
            return "not saved"

-- createoperator2 :: Operateur -> Handler Operateur
-- createoperator2 op = do 
--     let operateur = createOperator (nomOp op) (prenomOp op) (matricule op) (show $ email op) (passwordOp op) (T.unpack (photo op))
--     case operateur of
--         Right a -> do 
--             liftIO $ print a
--             sav <- liftIO $ saveOperator a
--             return op
--         Left b -> do 
--             sav <- liftIO $ putStrLn "Register Failed"
--             fail "pas enregistrer"

{-=========CONNECT AN OPERATOR =====-}
connectoperateur :: Operateur -> Handler Operateur
connectoperateur op = do 
    var <- liftIO $ connectOperator (matricule op) (passwordOp op)
    return op

{-======== DECONNECT AN OPERATOR =====-}
deconnectoperateur :: Operateur -> Handler Operateur
deconnectoperateur op = do 
    var <- liftIO $ deconnectOperator (matricule op) (passwordOp op)
    return op


{-========= LIST OF PATIENTS =======-}
patients :: Handler [Patient]
patients = do 
    pat <- (liftIO readPatient)
    return pat 

{-========= TAKE A PATIENT =======-}
patient :: Int -> Handler Patient
patient code = do 
    var <- (liftIO $ readAPatient code)
    return $ head var 

{-========= DELETE A PATIENT =======-}
deletepatient :: Int -> Handler NoContent
deletepatient code = do 
    var <- (liftIO $ deletePatient code)
    return $ error ""

{-========= UPDATE A PATIENT =======-}
updatepatient :: Patient -> Handler Patient
updatepatient pat = do 
    let nom = nameOf pat 
        prenom = firstNameOf pat
        mail = emailOf pat
        codepas = code pat 
        image = photoOf pat 
        statut = statutP pat 
    var <- (liftIO $ (updatePatient codepas nom prenom mail image statut))
    return pat

{-========= CREATE A PATIENT ======-}
createpatient :: NomOp -> PrenomOp -> String -> String -> Int -> Handler String
createpatient nom prenom email photo code = do 
    let pat = createHelper nom prenom email photo code
    case pat of
        Right a -> do 
            liftIO $ print a
            sav <- liftIO $ savePatient a
            return "saved"
        Left b -> do 
            sav <- liftIO $ putStrLn "Register Failed"
            return "not saved"

{-======== CONNECT A PATIENT =======-}
connectpatient :: Patient -> Handler Patient
connectpatient pat = do 
    var <- liftIO $ connectPatient (code pat) (nameOf pat)
    return pat

{-======= DECONNECT A PATIENT =====-}
deconnectpatient :: Patient -> Handler Patient
deconnectpatient pat = do 
    var <- liftIO $ deconnectPatient (code pat) (nameOf pat)
    return pat