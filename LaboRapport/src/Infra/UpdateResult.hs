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
    request = "UPDATE resultat SET idAnal = ?, interpretation = ?, conclusion = ?, fiche = ?, prescripteur = ?, numDossier = ?, lineResults = ?, nomLaborantin = ? WHERE idResult = ?"

    updateResult :: Int -> Int -> String -> String -> IdFiche  -> String -> Int -> [LineResult] -> String -> IO ()
    updateResult idResult idAnal interpretation conclusion idfiche  prescripteur numDossier lineResults nomLaborantin = do 
        print "1111111111111111"
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "raoul", connectPassword = "Raoul102030!!", connectDatabase = "labo_rapport"}
        res <- execute conn request (idAnal :: Int, interpretation :: String, conclusion :: String, idfiche :: Int, prescripteur :: String, numDossier :: Int, show lineResults, nomLaborantin :: String, idResult :: Int)
        print "222222222222222222222"
        close conn 
        print res