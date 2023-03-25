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

{-Here the first endpoint return the list of operators in a json format-}
type API = "operateurs" :> Get '[JSON] [Operateur]
-- this endpoint return the list of patient in a json format
    :<|> "patients" :> Get '[JSON] [Patient]
-- this endpoint take a matricule of string an return an operator in a json format
    :<|> "operateurs" :> Capture "matricule" String :> Get '[JSON] Operateur
-- this endpoint take a code of Int an return a patient in a json format
    :<|> "patients" :> Capture "name" String  :> Get '[JSON] Patient
-- this endpoint take a matricule of string an Delete an Operator
    :<|> "operateurs" :> Capture "matricule" String :> DeleteNoContent
-- this endpoint take a code of Int an Delete a patient
    :<|> "patients" :> Capture "name" String  :> DeleteNoContent
-- this endpoint take an operator of json an return a string modified to an operator update
    :<|> "operateurs" :> ReqBody '[JSON] Operator :> Put '[JSON] String
-- this endpoint take a password of json an return a string modified to a password update
    :<|> "operateurs" :> "password":> ReqBody '[JSON] Pass :> Put '[JSON] String
-- this endpoint take a patient of json an return a string modified to a patient update
    :<|> "patients" :> ReqBody '[JSON] Together :> Put '[JSON] String
-- this endpoint take an operator2 of json an return a string successful to an operator created
    :<|> "operateurs" :> ReqBody '[JSON] Operateur2 :> Post '[JSON] String
-- this endpoint take an Patient2 of json an return a string successful to a patient created
    :<|> "patients" :> ReqBody '[JSON] Patient2 :> Post '[JSON] String
-- this endpoint take login = "matricule" and login = "password" as query params an return a string connected to an operator connexion
    :<|> "operateurs" :> "connexion" :> QueryParams "login" String :> Post '[JSON] String
-- this endpoint take login = "code" and login = "name" as query params an return a string connected to a patient connexion
    :<|> "patients" :> "connexion" :> QueryParams "login" String :> Post '[JSON] String
-- this endpoint take login = "matricule" and login = "password" as query params an return a string deconnected to an operator deconnexion
    :<|> "operateurs" :> "deconnexion" :> QueryParams "login" String :> Post '[JSON] String
-- this endpoint take login = "code" and login = "name" as query params an return a string deconnected to a patient deconnexion
    :<|> "patients" :> "deconnexion" :> QueryParams "login" String :> Post '[JSON] String
-- this endpoint take a name of string an return a string success to create a role
    :<|> "role" :> Capture "name" String :> Post '[JSON] String
-- this endpoint return all the roles
    :<|> "role" :> "all roles" :> Get '[JSON] [Role]
-- this endpoint take a nomrole of string an return all the users that play that role
    :<|> "role" :> Capture "nomrole" String :> Get '[JSON] [User Operateur Patient]
-- this endpoint take a matricule of string a nomrole of string an return string successful for the update of an operator role
    :<|> "operateurs" :> Capture "matricule" String :> "role" :> Capture "nomrole" String :> Put '[JSON] String
-- this endpoint take a code of int and a nomrole of string an return successful for the update of a patient role
    :<|> "patients" :> Capture "name" String :> "role" :> Capture "nomrole" String :> Put '[JSON] String
-- this endpoint take a matricule of string an return all the role play by an operator
    :<|> "operateurs" :> Capture "matricule" String :> "roles" :> Get '[JSON] [String]
-- this endpoint take a code of int an return all the role play by a patient
    :<|> "patients" :> Capture "name" String :> "roles" :> Get '[JSON] [String]


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
    :<|> allroles
    :<|> listOfUser
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
   liftIO readPatient
    

{-========= TAKE A PATIENT =======-}
patient :: String -> Handler Patient
patient name = do
    liftIO $ readByName name
    

{-========= DELETE A PATIENT =======-}
deletepatient :: String  -> Handler NoContent
deletepatient nom = do
    var <- liftIO $ deleteByName nom
    return $ error var

{-========= UPDATE A PATIENT =======-}
updatepatient :: Together -> Handler String
updatepatient pat = do
    let someName = nomPatient pat
        infos = newParams pat
    liftIO $ updateByName someName (newNom infos) (newPrenom infos) (newMail infos)

    
{-========= CREATE A PATIENT ======-}
createpatient :: Patient2 -> Handler String
createpatient patient = do
    liftIO $ print $ (nameOf2 patient) ++ " " ++ (firstNameOf2 patient) ++ " " ++ (show $ emailOf2 patient) ++ " " ++ (T.unpack $ photoOf2 patient)
    pat <- liftIO $ createPatient (nameOf2 patient) (firstNameOf2 patient) (show $ emailOf2 patient) (T.unpack $ photoOf2 patient)
    return "le patient a ete cree avec succes"

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


allroles :: Handler [Role]
allroles = liftIO listOfRoles

listOfUser :: String -> Handler [User Operateur Patient]
listOfUser nameOfRole = liftIO $ userRoles (MkNom nameOfRole)



-- assign a role to an operator, given his matricule 
operateurs :: String -> String -> Handler String
operateurs  mat nom = do
    let nomRole = MkNom  nom
    operatorFounded <- liftIO $ foundOperator mat
    assignedRoleTo <- liftIO $ asignRole nomRole (Operateur operatorFounded)
        --liftIO $ print assignedRoleTo
    return  "successful"

-- assign a role to a patient, given his access's code
patients' :: String -> String -> Handler String
patients' nameOfPatient someName = do
    let nomrole = MkNom someName
    patientFounded <- liftIO $ readByName nameOfPatient
        --liftIO $ print patientFounded
    assignedRoleTo <- liftIO $ asignRole nomrole (Patient patientFounded)
    return  "successful"

    -- search list of all the role played by an operator 
opList :: String -> Handler [String]
opList mat = do
    operatorFounded <- liftIO $ foundOperator mat
    roleList <- liftIO $ searchRole (Operateur operatorFounded) "roles.txt"
    case roleList of
        [] -> fail "fail"
        xs -> return $ fmap getNom xs

    --  search list of all the role played by a patient 
paList :: String -> Handler [String]
paList name = do
    patientFounded <- liftIO $ readByName name
    roleList <- liftIO $ searchRole (Patient patientFounded) "roles.txt"
    case roleList of
        [] -> fail $ name ++ " ne joue aucun role"
        something -> return $ fmap getNom something