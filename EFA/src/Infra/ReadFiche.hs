{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE CPP, BangPatterns, ScopedTypeVariables #-}

module Infra.ReadFiche where

     {-========== Importation ===========-}
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result
    import Common.SimpleTypes
    import Data.Aeson.TH

    requestselect :: Query
    requestselect = "SELECT * FROM fiche"

    requestselect' :: Query
    requestselect' = "SELECT * FROM fiche WHERE idFiche = ?"

    {-======== Function to read a list of fiche =========-}
    readFiche :: IO [Fiche]
    readFiche = do
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectDatabase = "haskell", connectPassword = "efa", connectUser = "ntet", connectPort = 3306}
        res <- query_ conn requestselect
        close conn
        print res
        return res

    {-======= Function to read a fiche =========-}
    readAFiche :: Int -> IO Fiche
    readAFiche idFiche = do
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectDatabase = "haskell", connectPassword = "efa", connectUser = "ntet", connectPort = 3306}
        res <- query conn requestselect'(Only idFiche) 
        close conn
        print $ head res
        return $ head res
    