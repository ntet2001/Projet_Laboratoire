{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module App.Funzione where

import Data.Aeson
import Data.Aeson.TH
import Data.Proxy
import GHC.Generics
import Network.HTTP.Client (newManager, defaultManagerSettings)
import Servant.API
import Servant.Client
import qualified Data.Text as T
import Servant.Types.SourceT (foreach)
import Data.ByteString.Lazy
import Text.ParserCombinators.Parsec
import qualified Data.List as L
import Common.SimpleTypes

import qualified Servant.Client.Streaming as S
import Domain.CreateFiche (patientCheck, createFiche)
import Infra.SaveFiche (saveFiche)



type Nom = String
type NomOp = Nom
type PrenomOp = Nom
type NomPatient = Nom
type PrenomPatient = Nom
type Matricule = String
type Identifiant = String
type Photo = T.Text

data Statut = Connecter | Deconnecter | Supprimer | Bloquer | Aucun deriving (Show,Eq,Read,Generic)
$(deriveJSON defaultOptions ''Statut)


data Email2 = MkEmail2
    {identifiant2 :: Identifiant
    ,domaine2 :: String
    ,extension2 :: String
    } deriving (Eq,Read,Generic)
$(deriveJSON defaultOptions ''Email2)

instance Show Email2 where
    show email = (identifiant2 email) ++ "@" ++ (domaine2 email) ++ "." ++ (extension2 email)

data Patient2 = MkPatient2
        {nameOf2 :: Nom
        ,firstNameOf2 :: Nom
        ,emailOf2 :: Email2
        ,photoOf2 :: Photo
        ,code2 :: Int
        ,statutP2 :: Statut
        } deriving (Show, Read,Eq,Generic)
$(deriveJSON defaultOptions ''Patient2)

fonctpoint :: String -> String
fonctpoint xs
    | nbrePoints >= 1 = if L.last xs == '.' then "" 
            else f xs 
    | otherwise = xs
        where   nbrePoints = L.length $ L.elemIndices '.' xs
                f :: String -> String 
                f xs =  let (i:is) = L.elemIndices '.' xs 
                            (l:m:ys) = [x | x <- [xs !! j | j <- [i..(L.length xs)]]]
                        in if [l,m] == ".." then "" 
                        else xs


parserEmail :: Parser (Identifiant, String , String) -- jean94@domain.com
parserEmail = do 
    n1 <- many (noneOf "@")
    let identifiant = fonctpoint n1
    char '@'
    domaine <- many (letter <|> digit)
    char '.'
    extension <- many (letter <|> digit <|> noneOf "@" )
    return (identifiant,domaine ,extension)

verificationEmail :: String -> Either ParseError (Identifiant,String,String)
verificationEmail email = parse parserEmail "email non valide" email


-- our api type, endpoint pour acceder à ce service dans IAM
type API = "patient" :> ReqBody '[JSON] Patient2 :> Post '[JSON] Int
        

-- our function to get informations from the service 


api :: Proxy API
api = Proxy

patient :: Patient2 -> ClientM Int
patient  = client api

-- function that use the client functions

queries :: Patient2 ->  ClientM Int
queries someValue = do 
    patient someValue



-- fonction au niveau applicatif qui appelle le domaine, et l'infra pour creer une fiche 

save' :: Int -> [String] -> String -> String -> String -> 
    Int -> String -> String -> IO ()
save' someId listAnalyse prescripteur  nom prenom dayOfBirth genre email = do
    let decodeEmail = verificationEmail email
    case decodeEmail of
        Left _ -> fail "attention, erreur sur le format de l'email"
        Right (x,y,z) -> 
            if L.null nom || L.null prenom then fail "l'email est juste mais le nom ou le prenom est vide"
            else do
                let info = MkPatient nom prenom dayOfBirth genre email
                    emailOfTypeEmail2 = MkEmail2 x y z
                    elementOfTypePatient2 = MkPatient2 nom prenom emailOfTypeEmail2 "11200012010" 0000 Aucun
                someFiche <- createFiche someId listAnalyse prescripteur info
                saveFiche someFiche
                manager' <- newManager defaultManagerSettings
                --let conversion = toJSON elementOfTypePatient2
                res <- runClientM (queries elementOfTypePatient2) (mkClientEnv manager' (BaseUrl Http "localhost" 8080 ""))
                case res of
                    Left err -> putStrLn $ "Error: " ++ show err
                    Right something -> print $ show something
            



