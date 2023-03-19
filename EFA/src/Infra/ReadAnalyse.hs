{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE BlockArguments #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Infra.ReadAnalyse where


import Common.SimpleTypes
import Database.MySQL.Simple
import qualified Database.MySQL.Simple.QueryResults as Q
import qualified Database.MySQL.Simple.Result as R
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


readaAnalyse :: IdAnalyse -> IO Analyse
readaAnalyse  someId = do
    connexiontoDb <- connect defaultConnectInfo  { connectUser = "raoul",  connectPassword = "Raoul102030!!", connectDatabase = "EFA"}
    databaseContent <- query connexiontoDb "SELECT * FROM analyse WHERE idAnalyse = ?" (Only someId)
    close connexiontoDb
    print $ head databaseContent
    return $ head databaseContent

readAnalyse :: IO [Analyse]
readAnalyse = do
    connexiontoDb <- connect defaultConnectInfo  { connectUser = "root",  connectPassword = "ntetigor2001", connectDatabase = "EFA"}
    databaseContent <- query_ connexiontoDb "SELECT * FROM analyse"
    close connexiontoDb
    print databaseContent
    return databaseContent
