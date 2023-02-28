{-# LANGUAGE OverloadedStrings, BangPatterns, DataKinds #-}
{-# LANGUAGE FlexibleInstances, FlexibleContexts  #-}
module Infra.UpdateAnalyse where

import Servant
import Common.SimpleTypes
import Domain.CreateAnalyse
import App.CommonVerification
import Data.Aeson (ToJSON, FromJSON)
import Database.MySQL.Simple
import Database.MySQL.Simple.Types
import Control.Monad.IO.Class (liftIO)

updateAnal :: Analyse -> IO String
updateAnal a = do
      conn <- connect connectionInfos
      val <- execute conn ("update analyses set nomAnalyse = ?,valUsuel = ?,Categorie = ? where idAnalyse= ? ") (nomAnalyse a, show (valUsuel a),  show (categorie a ), idAnalyse a) 
      print val
      return "modification reussie"

connectionInfos :: ConnectInfo
connectionInfos = ConnectInfo "localhost" 3306  "root" "Borice1999#" "geslabo" [] "" Nothing