{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE FlexibleContexts #-}

module Infra.DeleteResult where 

     {-========== Importation  of {mysql-simple, Common.SimpleTypes, Aeson} ===========-}
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result
    import Common.SimpleTypes
    import Data.Aeson.TH
    import Infra.ReadResult
    import Infra.UpdateRapport
    import Infra.ReadRapport
    

    {-======== the function request is the query send to our database =========-}
    requestDeleteResult :: Query 
    requestDeleteResult = "DELETE FROM resultat WHERE idResult = ?"

    -- evenement declencheur : suppression d'un resultat 
        -- si l'id du resultat est dans le contenu du rapport alors il est enleve 
        -- mettre la fonction dans un bloc try

    deleteResult :: Int -> IO String
    deleteResult idResult = do
        -- je sors le resultat correspondant a idResult
        leresultat <- readAResult idResult 
        -- je resors le rapport correspondant 
        lerapport <- readARapport (numDossier leresultat)
        -- check contenu du rapport 
        let currentContenu = contenu lerapport 
            contenuFiltre = filter (/= idResult) currentContenu
        -- nouveau rapport 
        updateRapport (idRapport lerapport) contenuFiltre
        -- connexion bd , pour suppression du resultat 
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "raoul", connectPassword = "Raoul102030!!", connectDatabase = "labo_rapport"}
        res <- execute conn requestDeleteResult (Only idResult)
        close conn
        if res == 1 then 
            return "Successful"
        else 
            return "Failed"
