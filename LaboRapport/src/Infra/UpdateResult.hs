{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE FlexibleContexts #-}

module Infra.UpdateResult where 

    {-========== Importation  of {mysql-simple, Common.SimpleTypes, Aeson} ===========-}
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result
    import Data.Aeson.TH
    import Common.SimpleTypes
    import Data.Time

    request :: Query 
    request = "UPDATE resultat SET idAnal = ?, interpretation = ?, conclusion = ?, infoPat = ?, prelevement = ?,   prescripteur = ?, numDossier = ?, lineResults = ?, nomLaborantin = ? WHERE idResult = ?"

    updateResult :: Int -> Int -> String -> String -> InfoPatient -> UTCTime -> String -> Int -> [LineResult] -> String -> IO ()
    updateResult idResult idAnal interpretation conclusion infoPat prelevement prescripteur numDossier lineResults nomLaborantin = do 
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "codeur", connectPassword = "codeur", connectDatabase = "labo_rapport"}
        res <- execute conn request (idAnal :: Int, interpretation :: String, conclusion :: String, show infoPat, prelevement, prescripteur :: String, numDossier :: Int, show lineResults, nomLaborantin :: String, idResult :: Int)
        close conn 
        print res