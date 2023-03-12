{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE FlexibleContexts #-}

module Infra.SaveResult where 

    {-========== Importation  of {mysql-simple, Common.SimpleTypes, Aeson} ===========-}
    import Database.MySQL.Simple
    import Database.MySQL.Simple.QueryResults
    import Database.MySQL.Simple.Result
    import Data.Aeson.TH
    import Common.SimpleTypes
    import Data.Time
    
    request :: Query 
    request = "INSERT INTO resultat (idAnal,interpretation,conclusion,fiche,prescripteur,numDossier,lineResults,nomLaborantin) VALUES (?,?,?,?,?,?,?,?)"

    saveResult :: Resultat -> IO String
    saveResult resultat = do 
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectPort = 3306, connectUser = "codeur", connectPassword = "codeur", connectDatabase = "labo_rapport"}
        res <- execute conn request (idAnal resultat :: Int, interpretation resultat :: String, conclusion resultat :: String, 
            fiche' resultat , prescripteurR resultat :: String, numDossier resultat :: Int, show $ lineResults resultat, nomLaborantin resultat :: String)
        close conn 
        print res
        if res == 1 then 
            return "Successful"
        else
            return "Failed"