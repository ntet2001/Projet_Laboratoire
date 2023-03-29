{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE FlexibleContexts #-}

module Infra.UpdateRapport where 

    {-========== Importation  of {mysql-simple, Common.SimpleTypes, Aeson} ===========-}
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result
    import Data.Aeson.TH
    import Common.SimpleTypes
    import Data.Time
    import Infra.ReadRapport
    

    request :: Query 
    request = "UPDATE rapport SET contenu = ? WHERE idRapport = ?"

    updateRapport :: Int -> [Int] -> IO String
    updateRapport idRapport contenu = do 
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "raoul", connectPassword = "Raoul102030!!", connectDatabase = "labo_rapport"}
        res <- execute conn request (show contenu, idRapport :: Int)
        close conn 
        if res == 1 then 
            return "success"
        else fail "failed"
    
--  function to update one report when deleting a result 

    updateRapportWhenDeleteResult :: Int -> Int -> IO Rapport 
    updateRapportWhenDeleteResult idRapport idResultat = undefined
        -- -- rapport correspondant 
        -- lerapport <- readRapport idRapport
        -- -- le contenu du rapport 
        -- let contenu = contenus lerapport


    