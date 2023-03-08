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

    {-======== the function request is the query send to our database =========-}
    request :: Query 
    request = "DELETE FROM resultat WHERE idResult = ?"

    deleteResult :: Int -> IO String
    deleteResult idResult = do
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "codeur", connectPassword = "codeur", connectDatabase = "labo_rapport"}
        res <- execute conn request (Only idResult)
        close conn
        if res == 1 then 
            return "Successful"
        else 
            return "Failed"
