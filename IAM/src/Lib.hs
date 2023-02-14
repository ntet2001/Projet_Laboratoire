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
import Infra.AssignRole
import Domain.CreateRole
import Infra.SearchRole
import Infra.SaveRole
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
    :<|> "patients" :> Capture "nom" String :> Capture "prenom" String :> Capture "email" String :> Capture "photo" String :> Post '[JSON] Int
    :<|> "connexionoperators" :> ReqBody '[JSON] Operateur :> Post '[JSON] Operateur
    :<|> "connexionpatients" :> ReqBody '[JSON] Patient :> Post '[JSON] Patient
    :<|> "deconnexionoperators" :> ReqBody '[JSON] Operateur :> Post '[JSON] Operateur
    :<|> "deconnexionpatients" :> ReqBody '[JSON] Patient :> Post '[JSON] Patient
    :<|> "roles" :> Capture "name" String :> Post '[JSON] String
    :<|> "operateurs" :> Capture "matricule" String :> "roles" :> Capture "nomrole" String :> Post '[JSON] String
    :<|> "patients" :> Capture "code" Int :> "roles" :>  Capture "nomrole" String :> Post '[JSON] String
    :<|> "opList" :> Capture "matricule" String :> Get '[JSON] [String]
    :<|> "paList" :> Capture "code" Int :> Get '[JSON] [String]
   

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
    :<|> roles 
    :<|> operateurs
    :<|> patients'
    :<|> opList
    :<|> paList

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
createpatient :: NomOp -> PrenomOp -> String -> String -> Handler Int
createpatient nom prenom email photo = do 
    pat <- liftIO $ createPatient nom prenom email photo
    return pat 

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


-- create a new role 
roles :: String -> Handler String
    --createNewRole Nothing = fail "entrer un nom de role !"
roles val = do
    let toNomRole = MkNom val
        newrole = createRole toNomRole
    liftIO $ print "ca marche"
    liftIO $ saveRole newrole "roles.txt" >> return "success"
    
-- assign a role to an operator, given his matricule 
operateurs :: String -> String -> Handler String 
operateurs  mat nom = do
    let nomRole = MkNom  nom
    operatorFounded <- liftIO $ foundOperator mat 
    assignedRoleTo <- liftIO $ asignRole nomRole (Operateur operatorFounded)
        --liftIO $ print assignedRoleTo
    return $ "ok, the operator which matricule is, " 
            ++  mat ++ " " ++ "have the role " ++  nom
    
-- assign a role to a patient, given his access's code
patients' :: Int -> String -> Handler String
patients' someCode someName = do
    let nomrole = MkNom someName
    patientFounded <- liftIO $ foundPatient someCode
        --liftIO $ print patientFounded
    assignedRoleTo <- liftIO $ asignRole nomrole (Patient patientFounded)
    return $ "ok, the patient which code is, " ++ show someCode ++ " "
         ++ "have the role " ++ someName
    
    -- search list of all the role played by an operator 
opList :: String -> Handler [String]
opList mat = do
    operatorFounded <- liftIO $ foundOperator mat 
    roleList <- liftIO $ searchRole (Operateur operatorFounded) "roles.txt"
    case roleList of 
        [] -> fail "sorry, the operateur don't have any role !"
        xs -> return $ fmap getNom xs 
    
    --  search list of all the role played by a patient 
paList :: Int -> Handler [String]
paList code = do
    patientFounded <- liftIO $ foundPatient code 
    roleList <- liftIO $ searchRole (Patient patientFounded) "roles.txt"
    case roleList of
        [] -> fail "sorry, the patient don't have any role !"
        something -> return $ fmap getNom something 