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


readAnalyse :: IdAnalyse -> IO Analyse
readAnalyse  someId = do
    connexiontoDb <- connect defaultConnectInfo  { connectUser = "raoul",  connectPassword = "Raoul102030!!", connectDatabase = "EFA"}
    databaseContent <- query_ connexiontoDb "SELECT * FROM analyse"
    let idFounded = [analyse | analyse <- databaseContent , someId == idAnalyse analyse]
    if L.null idFounded then fail "cet analyse n'existe pas encore"
    else do 
        close connexiontoDb
        return $ L.head idFounded

