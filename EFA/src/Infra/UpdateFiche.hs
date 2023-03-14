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

    request :: Query 
    request = "UPDATE fiche SET idAnalyses = ?, prescripteur = ?, infopatient = ? WHERE idFiche = ?"

    updateFiche :: Int -> [String] -> String -> InfoPatient -> IO ()
    updateFiche idFiche analyses prescripteur infoPatient = do 
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "root", connectPassword = "ntetigor2001", connectDatabase = "haskell"}
        res <- execute conn request (show analyses :: String, prescripteur :: String, show infoPatient, idFiche)
        close conn 
        print res