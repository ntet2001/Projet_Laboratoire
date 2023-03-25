{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE CPP, BangPatterns, ScopedTypeVariables #-}

module Infra.DeleteFiche where

     {-========== Importation ===========-}
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result
    import Common.SimpleTypes
    import Data.Aeson.TH

    request :: Query 
    request = "DELETE FROM fiche WHERE idFiche = ?"

    deleteFiche :: Int -> IO String
    deleteFiche idFiche = do
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "root", connectPassword = "ntetigor2001", connectDatabase = "haskell"}
        res <- execute conn request (Only idFiche)
        close conn
        if res == 1 then 
            return "Successful delete"
        else 
            return "Delete Failed"