{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE BlockArguments #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Infra.UpdateAnalyse where


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


updateAnalyse :: Analyse -> IO ()
updateAnalyse something = do
    connexion <- connect defaultConnectInfo  { connectUser = "root",  connectPassword = "Borice1999#", connectDatabase = "labo_rapport"}
    numberline <- execute connexion "UPDATE analyse SET  nomAnalyse = ?, valUsuel = ?, categorie = ? WHERE idAnalyse = ?" 
        (nomAnalyse something, show $ valUsuel something, show $ categorie something, idAnalyse something )
    print numberline




