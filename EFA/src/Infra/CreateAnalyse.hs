{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE BlockArguments #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Infra.CreateAnalyse where


import Common.SimpleTypes
import Database.MySQL.Simple
import qualified Database.MySQL.Simple.QueryResults as Q
import qualified Database.MySQL.Simple.Result as R
import Data.ByteString.Char8 
import Database.MySQL.Simple.Types
import Database.MySQL.Base.Types
import Text.ParserCombinators.Parsec
import qualified Data.List as L


instance Q.QueryResults Analyse where
    convertResults [fa,fb,fc,fd] [va,vb,vc,vd] = MkAnalyse a b c d
            where !a = R.convert fa va
                  !b = R.convert fb vb
                  !c = R.convert fc vc
                  !d = R.convert fd vd
    convertResults fs vs  = Q.convertError fs vs 4
    

createAnalyse  :: IdAnalyse -> String -> ValUsuel -> Categorie -> IO () 
createAnalyse someId someName someValue category = do
    connectToDatabase <- connect defaultConnectInfo { connectUser = "raoul",  connectPassword = "Raoul102030!!", connectDatabase = "EFA"}
    databaseContent <- query_ connectToDatabase "SELECT * FROM analyse"
    if L.elem someName $ fmap nomAnalyse databaseContent 
        then fail "cette analyse existe deja"
    else do 
        numberofline <- execute connectToDatabase "INSERT INTO analyse (idAnalyse, nomAnalyse, valUsuel, categorie) VALUES (?,?,?,?)" 
            (someId, someName, show someValue, show category) 
        close connectToDatabase
        print numberofline



    












