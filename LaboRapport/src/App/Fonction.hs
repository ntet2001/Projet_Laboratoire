{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
module App.Fonction where

import Domain.CreateAnalyse (createAnalyse', verifValUsuel, verifCategorie)
import Infra.SaveAnalyse (saveAnalyse)
import Common.SimpleTypes
import System.IO.Error
import Data.Aeson
import Data.Aeson.TH
import Data.Proxy
import GHC.Generics
import Text.ParserCombinators.Parsec
import qualified Data.List
import Network.HTTP.Client (newManager, defaultManagerSettings) 
import qualified Network.HTTP.Simple as NT
import Common.SimpleTypes
import Data.List
import Data.Aeson
import Data.Aeson.TH
import Data.Proxy
import GHC.Generics
import Text.ParserCombinators.Parsec
import Network.HTTP.Client (newManager, defaultManagerSettings) 
import qualified Network.HTTP.Simple as NT
import Common.SimpleTypes
import Control.Monad (Monad(return))

{- verifications au niveau applicatif : verifier que les parametres 
d'entre ne  sont pas vides-}

-- fonction d'envoie de fiche a rapport
sendAnalyseFiche :: Analyse2 -> IO()
sendAnalyseFiche analyse = do 
    let request = NT.setRequestBodyJSON analyse "POST http://localhost:8081/Analyse"
    response <- NT.httpJSON request :: IO (NT.Response Value)
    print $ NT.getResponseBody response

save :: String -> String -> String -> IO String
save nom value somecategory = do
    if null nom || null value || null somecategory 
        then fail "les parametres d'entree ne doivent pas etre vides"
    else do 
        let checkedValue = verifValUsuel value
        case checkedValue of
            Left msg1 -> fail $ msg1 ++ ": " ++ show value
            Right someValue -> do 
                let checkedCategorie = verifCategorie somecategory
                case checkedCategorie of 
                    Left msg2 -> fail $ msg2 ++ ": " ++ show somecategory
                    Right someCategorie -> do
                        let identifiant = "A-" ++ take 3 (nom)
                            analyse2 = MkAnalyse2 nom someValue someCategorie
                            result = createAnalyse' identifiant nom someValue someCategorie
                        saveAnalyse result
                        sendAnalyseFiche analyse2
                        return "Analyse enregistree avec success"

-------------------modify Analyse--------------------------
sendAnalyseFicheUpdate :: Analyse -> IO()
sendAnalyseFicheUpdate analyse = do 
    let request = NT.setRequestBodyJSON analyse "PUT http://localhost:8081/Analyse"
    response <- NT.httpJSON request :: IO (NT.Response Value)
    print $ NT.getResponseBody response


update :: String -> String -> String -> IO Analyse2
update nom value somecategory = do
    if null nom || null value || null somecategory 
        then fail "les parametres d'entree ne doivent pas etre vides"
    else do 
        let checkedValue = verifValUsuel value
        case checkedValue of
            Left msg1 -> fail $ msg1 ++ ": " ++ show value
            Right someValue -> do 
                let checkedCategorie = verifCategorie somecategory
                case checkedCategorie of 
                    Left msg2 -> fail $ msg2 ++ ": " ++ show somecategory
                    Right someCategorie -> do
                        let analyse = MkAnalyse2 nom someValue someCategorie
                        return analyse

---------------Delete Analyse----------------------------------
sendAnalyseFicheDelete :: String -> IO()
sendAnalyseFicheDelete idAnal = do 
    let analyse = MkAnalyse idAnal "aaa" Vide Biochimie
        request = NT.setRequestBodyJSON analyse "DELETE http://localhost:8081/Analyse"
    response <- NT.httpLbs request
    print $ NT.getResponseBody response                            

    --         something = createAnalyse identifiant nom (read value :: ValUsuel) (read somecategory :: Categorie)
    -- case something of
    --     Right someAnalyse -> do 
    --         saveAnalyse someAnalyse
    --         return someAnalyse
    --     Left msg -> fail msg

-- save' :: String -> String -> String -> String -> IO Analyse
-- save' identifiant nom value somecategory = undefined