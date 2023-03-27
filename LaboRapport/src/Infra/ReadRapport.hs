{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE FlexibleContexts #-}

module Infra.ReadRapport where

    {-========== Importation  of {mysql-simple, Common.SimpleTypes, Aeson} ===========-}
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result
    import Data.Aeson.TH
    import Common.SimpleTypes
    
    requestselect :: Query
    requestselect = "SELECT * FROM rapport"

    requestselect' :: Query
    requestselect' = "SELECT * FROM rapport WHERE idRapport = ?"

    {-======== Function to read a list of Results =========-}
    readRapport :: IO [Rapport]
    readRapport = do
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectDatabase = "labo_rapport", connectPassword = "Borice1999#", connectUser = "root", connectPort = 3306}
        print "11111111111111"
        res <- query_ conn requestselect
        close conn
        print res
        return res

    {-======= Function to read a Result who takes an id =========-}
    readARapport :: Int -> IO Rapport
    readARapport idRapport = do
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectDatabase = "labo_rapport", connectPassword = "Borice1999#", connectUser = "root", connectPort = 3306}
        res <- query conn requestselect'(Only idRapport) 
        close conn
        print $ head res
        return $ head res
