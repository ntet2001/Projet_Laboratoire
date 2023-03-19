{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE DeriveGeneric #-}

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
import GHC.Generics
import App.VerificationUpdate
import qualified Data.Text as T

{-here is the format to respect when you modified an operator-}
data Operator = MKOp
    { nom :: String
    ,prenom :: String
    ,matricul :: Matricule
    ,mail :: Email
    ,image :: Photo
    ,statut :: Statut 
    } deriving (Show,Eq,Read,Generic)
$(deriveJSON defaultOptions ''Operator)

{-here is the format to respect when you modified the password of an Operator-}
data Pass = MKpass
    { matriculepass :: String 
    ,oldPassword :: String
    ,newPassword :: String
    } deriving (Show,Eq,Read,Generic)
$(deriveJSON defaultOptions ''Pass)

type API = "operateurs" :> Get '[JSON] [Operateur] 
    :<|> "patients" :> Get '[JSON] [Patient] 
    :<|> "operateur" :> Capture "matricule" String :> Get '[JSON] Operateur 
    :<|> "patient" :> Capture "code" Int :> Get '[JSON] Patient
    :<|> "operateur" :> Capture "matricule" String :> DeleteNoContent
    :<|> "patient" :> Capture "code" Int :> DeleteNoContent
    :<|> "operateur" :> ReqBody '[JSON] Operator :> Put '[JSON] String
    :<|> "operateur" :> "password":> ReqBody '[JSON] Pass :> Put '[JSON] String
    :<|> "patient" :> ReqBody '[JSON] Patient :> Put '[JSON] String
    :<|> "operateur" :> ReqBody '[JSON] Operateur2 :> Post '[JSON] String
    :<|> "patient" :> ReqBody '[JSON] Patient2 :> Post '[JSON] Int
    :<|> "operateur" :> "connexion" :> QueryParams "login" String :> Post '[JSON] String
    :<|> "patient" :> "connexion" :> QueryParams "login" String :> Post '[JSON] String
    :<|> "operateur" :> "deconnexion" :> QueryParams "login" String :> Post '[JSON] String
    :<|> "patient" :> "deconnexion" :> QueryParams "login" String :> Post '[JSON] String
    :<|> "role" :> Capture "name" String :> Post '[JSON] String
    :<|> "operateur" :> Capture "matricule" String :> "role" :> Capture "nomrole" String :> Put '[JSON] String
    :<|> "patient" :> Capture "code" Int :> "role" :> Capture "nomrole" String :> Put '[JSON] String
    :<|> "operateur" :> Capture "matricule" String :> "roles" :> Get '[JSON] [String]
    :<|> "patient" :> Capture "code" Int :> "roles" :> Get '[JSON] [String]
   

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
    :<|> updatepass
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
updateoperator :: Operator -> Handler String
updateoperator op = do 
    let name = nom op 
        lastname = prenom op
        mat = matricul op 
        email = mail op
        photo = image op 
        status = statut op
    var <- liftIO $ verifUpdateInfo name lastname mat email photo status
    return var

updatepass :: Pass -> Handler String
updatepass pass = do 
    var <- liftIO $ verifUpdatePass (oldPassword pass) (newPassword pass) (matriculepass pass)
    return var
{-======= CREATE AN OPERATOR ========-}
-- createoperator :: Operateur2 -> Handler String
-- createoperator operateur = do 
--     let operateur = createOperator nom prenom matricule email password photo
--     case operateur of
--         Right a -> do 
--             liftIO $ print a
--             sav <- liftIO $ saveOperator a
--             return "successful"
--         Left b -> do 
--             sav <- liftIO $ putStrLn "fail"
--             return "fail"

createoperator :: Operateur2 -> Handler String
createoperator op = do 
    let operateur = createOperator (nomOp2 op) (prenomOp2 op) (matricule2 op) (show $ email2 op) (passwordOp2 op) (T.unpack (photo2 op))
    case operateur of
        Right a -> do 
            liftIO $ print a
            sav <- liftIO $ saveOperator a
            return "successful"
        Left b -> do 
            sav <- liftIO $ putStrLn "Register Failed"
            fail "fail"

{-=========CONNECT AN OPERATOR =====-}
connectoperateur :: [String] -> Handler String
connectoperateur [x,y] = do 
    var <- liftIO $ connectOperator x y
    return var

{-======== DECONNECT AN OPERATOR =====-}
deconnectoperateur :: [String] -> Handler String
deconnectoperateur [x,y] = do 
    var <- liftIO $ deconnectOperator x y 
    return var


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
updatepatient :: Patient -> Handler String
updatepatient pat = do 
    let nom = nameOf pat 
        prenom = firstNameOf pat
        mail = emailOf pat
        codepas = code pat 
        image = photoOf pat 
        statut = statutP pat 
    var <- (liftIO $ (updatePatient codepas nom prenom mail image statut))
    return "successful"

{-========= CREATE A PATIENT ======-}
createpatient :: Patient2 -> Handler Int
createpatient patient = do 
    liftIO $ print $ (nameOf2 patient) ++ " " ++ (firstNameOf2 patient) ++ " " ++ (show $ emailOf2 patient) ++ " " ++ (T.unpack $ photoOf2 patient)
    pat <- liftIO $ createPatient (nameOf2 patient) (firstNameOf2 patient) (show $ emailOf2 patient) (T.unpack $ photoOf2 patient)
    return pat

{-======== CONNECT A PATIENT =======-}
connectpatient :: [String]-> Handler String
connectpatient [code,nom] = do 
    var <- liftIO $ connectPatient (read code :: Int) nom
    return var

{-======= DECONNECT A PATIENT =====-}
deconnectpatient :: [String] -> Handler String
deconnectpatient [code,nom] = do 
    var <- liftIO $ deconnectPatient (read code :: Int) nom
    return var


-- create a new role 
roles :: String -> Handler String 
    --createNewRole Nothing = fail "entrer un nom de role !"
roles val = do
    let toNomRole = MkNom val
        newrole = createRole toNomRole
    liftIO $ print "ca marche"
    liftIO $ saveRole newrole "roles.txt" >> return "successful"
    
-- assign a role to an operator, given his matricule 
operateurs :: String -> String -> Handler String 
operateurs  mat nom = do
    let nomRole = MkNom  nom
    operatorFounded <- liftIO $ foundOperator mat 
    assignedRoleTo <- liftIO $ asignRole nomRole (Operateur operatorFounded)
        --liftIO $ print assignedRoleTo
    return $ "successful"
    
-- assign a role to a patient, given his access's code
patients' :: Int -> String -> Handler String
patients' someCode someName = do
    let nomrole = MkNom someName
    patientFounded <- liftIO $ foundPatient someCode
        --liftIO $ print patientFounded
    assignedRoleTo <- liftIO $ asignRole nomrole (Patient patientFounded)
    return $ "successful"
    
    -- search list of all the role played by an operator 
opList :: String -> Handler [String]
opList mat = do
    operatorFounded <- liftIO $ foundOperator mat 
    roleList <- liftIO $ searchRole (Operateur operatorFounded) "roles.txt"
    case roleList of 
        [] -> fail "fail"
        xs -> return $ fmap getNom xs
    
    --  search list of all the role played by a patient 
paList :: Int -> Handler [String]
paList code = do
    patientFounded <- liftIO $ foundPatient code 
    roleList <- liftIO $ searchRole (Patient patientFounded) "roles.txt"
    case roleList of
        [] -> fail "fail"
        something -> return $ fmap getNom something 