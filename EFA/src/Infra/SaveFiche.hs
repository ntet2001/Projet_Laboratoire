{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE CPP, BangPatterns, ScopedTypeVariables #-}

module Infra.SaveFiche where

    {-========== Importation ===========-}
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result
    import Common.SimpleTypes
    import Data.Aeson.TH

    request :: Query 
    request = "INSERT INTO fiche (infoPatient,idAnalyses,prescripteur) VALUES (?,?,?)"

    saveFiche :: Fiche -> IO ()
    saveFiche fiche = do 
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "root", connectPassword = "ntetigor2001", connectDatabase = "haskell"}
        res <- execute conn request (show $ patientInfos fiche, show $ analyses fiche :: String, prescripteur fiche :: String)
        close conn 
        print res