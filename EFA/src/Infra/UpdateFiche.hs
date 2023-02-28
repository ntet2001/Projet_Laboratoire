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

    updateFiche :: Fiche -> IO ()
    updateFiche fiche = do 
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "ntet", connectPassword = "efa", connectDatabase = "haskell"}
        res <- execute conn request (show $ analyses fiche :: String, prescripteur fiche :: String, show $ infoPatient fiche, idFiche fiche)
        close conn 
        print res