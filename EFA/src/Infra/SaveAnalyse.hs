{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE BlockArguments #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Infra.SaveAnalyse where


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
    

saveAnalyse  :: Analyse -> IO () 
saveAnalyse analyse = do
    connectToDatabase <- connect defaultConnectInfo { connectUser = "raoul",  connectPassword = "Raoul102030!!", connectDatabase = "EFA"}
    numberofline <- execute connectToDatabase "INSERT INTO analyse (idAnalyse, nomAnalyse, valUsuel, categorie) VALUES (?,?,?,?)" 
            (idAnalyse analyse, nomAnalyse analyse, show $ valUsuel analyse, show $ categorie analyse) 
    close connectToDatabase
    print numberofline



    












