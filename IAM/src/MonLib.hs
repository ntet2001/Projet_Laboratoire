-- {-# LANGUAGE DataKinds       #-}
-- {-# LANGUAGE TemplateHaskell #-}
-- {-# LANGUAGE TypeOperators   #-}

module MonLib  where 

-- import Common.SimpleType
-- import Domain.AssignRole
-- import Domain.CreateRole
-- import Domain.SearchRole
-- import Infra.SaveRole
-- import Data.Aeson
-- import Data.Aeson.TH
-- import Network.Wai
-- import Network.Wai.Handler.Warp
-- import Servant
-- import Control.Monad.IO.Class
-- import Infra.ReadOperateur (foundOperator)
-- import Infra.ReadPatient (foundPatient)

-- startApp :: IO ()
-- startApp = run 8080 app 

-- app :: Application
-- app = serve api server

-- api :: Proxy API
-- api = Proxy

-- type API = "roles" :> Capture "name" String :> Post '[JSON] String
--     :<|> "operateurs" :> Capture "matricule" String :> "roles" :> Capture "nomrole" String :> Post '[JSON] String
--     :<|> "patients" :> Capture "code" Int :> "roles" :>  Capture "nomrole" String :> Post '[JSON] String
--     :<|> "opList" :> Capture "matricule" String :> Get '[JSON] [String]
--     :<|> "paList" :> Capture "code" Int :> Get '[JSON] [String]


-- server :: Server API
-- server = roles 
--     :<|> operateurs
--     :<|> patients
--     :<|> opList
--     :<|> paList
    
-- role :: Handler [Role]
-- role = return [MkRole (MkNom "admin") [], MkRole (MkNom "patient") [ConsAccessCode 20033655]]

-- --create a newrole and save the role created
-- roles :: String -> Handler String
-- --createNewRole Nothing = fail "entrer un nom de role !"
-- roles val = do
--     let toNomRole = MkNom val
--         newrole = createRole toNomRole
--     liftIO $ print "ca marche"
--     liftIO $ saveRole newrole "roles.txt" >> return "success"

-- -- assign a role to an operator, given his matricule 
-- operateurs :: String -> String -> Handler String 
-- operateurs  mat nom = do
--     let nomRole = MkNom  nom
--     operatorFounded <- liftIO $ foundOperator mat 
--     assignedRoleTo <- liftIO $ asignRole nomRole (Operateur operatorFounded)
--     --liftIO $ print assignedRoleTo
--     return $ "ok, the operator which matricule is, " 
--             ++  mat ++ " " ++ "have the role " ++  nom

-- -- assign a role to a patient, given his access's code
-- patients :: Int -> String -> Handler String
-- patients someCode someName = do
--     let nomrole = MkNom someName
--     patientFounded <- liftIO $ foundPatient someCode
--     --liftIO $ print patientFounded
--     assignedRoleTo <- liftIO $ asignRole nomrole (Patient patientFounded)
--     return $ "ok, the patient which code is, " ++ show someCode ++ " "
--          ++ "have the role " ++ someName

-- -- search list of all the role played by an operator 
-- opList :: String -> Handler [String]
-- opList mat = do
--     operatorFounded <- liftIO $ foundOperator mat 
--     roleList <- liftIO $ searchRole (Operateur operatorFounded) "roles.txt"
--     case roleList of 
--         [] -> fail "sorry, the operateur don't have any role !"
--         xs -> return $ fmap getNom xs 

-- --  search list of all the role played by a patient 
-- paList :: Int -> Handler [String]
-- paList code = do
--     patientFounded <- liftIO $ foundPatient code 
--     roleList <- liftIO $ searchRole (Patient patientFounded) "roles.txt"
--     case roleList of
--         [] -> fail "sorry, the patient don't have any role !"
--         something -> return $ fmap getNom something 



         




