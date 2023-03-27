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
    requestselect = "SELECT * FROM resultat WHERE fiche = ?" 
    -- fiche' est la fonction qui permet de connaitre l'id de la fiche contenue dans le resultat

    requestselect' :: Query
    requestselect' = "SELECT * FROM resultat WHERE idResult = ?"

    {-======== Function to read a list of Results =========-}
    -- je fais  une fonction qui ressort la  liste des resultats des analyses d'une fiche enregistree dans la bd

    readResultFiche :: Int -> IO [Resultat]
    readResultFiche idDeLaFiche = do
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectDatabase = "labo_rapport", connectPassword = "Borice1999#", connectUser = "root", connectPort = 3306}
        res <- query conn requestselect (Only idDeLaFiche)
        close conn
        print res
        return res

    {-======= Function to read a Result who takes an id =========-}
    -- c'est une fonctio qui permet de retrouver un resultat a partir de son identifiant, c'est un entity

    readAResult:: Int -> IO Resultat
    readAResult idResult = do
        conn <- connect defaultConnectInfo {connectHost = "localhost", connectDatabase = "labo_rapport", connectPassword = "Borice1999#", connectUser = "root", connectPort = 3306}
        res <- query conn requestselect'(Only idResult) 
        close conn
        print $ head res
        return $ head res