{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE FlexibleContexts #-}

module Infra.SaveRapport where 

    {-========== Importation  of {mysql-simple, Common.SimpleTypes, Aeson} ===========-}
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result
    import Data.Aeson.TH
    import Data.Aeson
    import Common.SimpleTypes
    import Data.Time
    


    request :: Query 
    request = "INSERT INTO rapport (fiche,contenu,dateCreated,dateUpdated,idRapport) VALUES (?,?,?,?,?)"

    saveRapport :: Rapport -> IO String
    saveRapport rapport = do 
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "root", connectPassword = "Borice1999#", connectDatabase = "labo_rapport"}
        res <- execute conn request (show $ fiche rapport, show $ contenu rapport :: String, dateCreatedRapport rapport, dateUpdatedRapport rapport,idRapport rapport :: Int)
        close conn 
        print res
        if res == 1 then 
            return "Successful"
        else
            return "Failed"