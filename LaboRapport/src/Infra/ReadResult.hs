{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE FlexibleContexts #-}

module Infra.ReadResult where 

    {-========== Importation  of {mysql-simple, Common.SimpleTypes, Aeson} ===========-}
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result
    import Data.Aeson.TH
    import Common.SimpleTypes (Resultat)
    
    requestselect :: Query
    requestselect = "SELECT * FROM resultat"

    requestselect' :: Query
    requestselect' = "SELECT * FROM resultat WHERE idResult = ?"

    {-======== Function to read a list of Results =========-}
    readResult :: IO [Resultat]
    readResult = do
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectDatabase = "labo_rapport", connectPassword = "codeur", connectUser = "codeur", connectPort = 3306}
        res <- query_ conn requestselect
        close conn
        print res
        return res

    {-======= Function to read a Result who takes an id =========-}
    readAResult:: Int -> IO Resultat
    readAResult idResult = do
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectDatabase = "labo_rapport", connectPassword = "codeur", connectUser = "codeur", connectPort = 3306}
        res <- query conn requestselect'(Only idResult) 
        close conn
        print $ head res
        return $ head res