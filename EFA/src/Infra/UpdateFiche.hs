{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE CPP, BangPatterns, ScopedTypeVariables #-}

module Infra.UpdateFiche where

    {-========== Importation ===========-}
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result
    import Common.SimpleTypes
    import Data.Aeson.TH
    import Data.Aeson
    import qualified Network.HTTP.Simple as NT
    import Infra.ReadFiche

    request :: Query 
    request = "UPDATE fiche SET idAnalyses = ?, prescripteur = ?, infopatient = ? WHERE idFiche = ?"

    updateFiche :: Int -> [String] -> String -> InfoPatient -> IO ()
    updateFiche idFiche analyses prescripteur infoPatient = do 
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "root", connectPassword = "Borice1999#", connectDatabase = "EFA"}
        res <- execute conn request (show analyses :: String, prescripteur :: String, show infoPatient, idFiche)
        close conn 
        print res

    
        -- update de le fiche qui se propage dans IAM 

    impactIAM :: Int -> [String] -> String -> InfoPatient -> IO String
    impactIAM idFiche analyses prescripteur infoPatient = do 
        -- cherche la fiche dont l'id est idFiche
        foundedFiche <- readAFiche idFiche
        -- ressort les inforamtions du patient sur la fiche dont l'id est idFiche
        let infosSurFiche = patientInfos foundedFiche
            -- patient identifié par le nom : contenation nom et prenom
            currentName = nom infosSurFiche ++ " " ++ prenom infosSurFiche
        -- cherche le patient dont le nom est contenu dans la fiche trouvée : pour eviter qu'une fiche soit mise a jour alors que le patient n'est pas encore enregistre
        requette <- NT.parseRequest  $ "GET http://localhost:8080/patients/" ++ currentName
        jsonResponse <-  NT.httpJSON requette :: IO (NT.Response Value)
        let jsonPatient = NT.getResponseBody jsonResponse
        case jsonPatient of
            Object listePatient -> do
                -- verifie si le nom sur la fiche correspond au nom du patient trouve
                if null listePatient then do 
                    return $ "le patient dont le nom est " ++ currentName ++ " n'est pas enregistre"    
                else do
                    -- requette pour mise a jour des infos dans la bd
                    conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "root", connectPassword = "Borice1999#", connectDatabase = "EFA"}
                    res <- execute conn request (show analyses :: String, prescripteur :: String, show infoPatient, idFiche)
                -- construit le type semiPatient avec les nouvelles infos sur la patient en parametres de updateFiche 
                    let someSemiPatient = ConsP (nom infoPatient) (prenom infoPatient) (email infoPatient)
                -- construit together que je dois envoyer dans le body de la requette pour l'end point sur IAM
                        togetherElement = ConsT currentName someSemiPatient
                        -- requette pour update le patient dans IAM
                        request' = NT.setRequestBodyJSON togetherElement "PUT http://localhost:8080/patients"
                    response <- NT.httpJSON request' :: IO (NT.Response Value)
                    print $ NT.getResponseBody response
                    close conn 
                    print res
                    return $ "la fiche dont l'id est " ++ show idFiche ++ " a ete mise jour"
            _ -> return "erreur, mis a jour impossible "

    
            -- update de le fiche qui se propage dans LaboRapport 

    impactLaboRapport :: Fiche -> IO String
    impactLaboRapport uneFiche = do 
        -- requette pour acceder a l'end point de laboRapport qui modifie une fiche dans un rapport 
        let requette = NT.setRequestBodyJSON uneFiche "PUT http://localhost:8082/rapport/fiche"
        response <- NT.httpJSON requette :: IO (NT.Response Value)
        print $ NT.getResponseBody response
        return $ "le rapport correspondant a la fiche dont l'id est " ++ show (idFiche uneFiche) ++ " a ete mis a jour"

