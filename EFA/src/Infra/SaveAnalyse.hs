{-# LANGUAGE OverloadedStrings, BangPatterns, DataKinds #-}
{-# LANGUAGE FlexibleInstances, FlexibleContexts  #-}

module Infra.SaveAnalyse where

import Servant
import Common.SimpleTypes
import Domain.CreateAnalyse
import App.CommonVerification
import Data.Aeson (ToJSON, FromJSON)
import Database.MySQL.Simple
import Database.MySQL.Simple.Types
import Control.Monad.IO.Class (liftIO)

-- import qualified Data.Text as T
-- import qualified Data.Text.Lazy as L
-- import Database.MySQL.Simple.Param
    



createAnal :: Analyse -> IO String
createAnal a = do
      conn <- connect connectionInfos
      val <- execute conn ("insert into analyses (idAnalyse,nomAnalyse,valUsuel,Categorie) values (?,?,?,?)") (idAnalyse a, nomAnalyse a, show (valUsuel a),  show (categorie a )) 
      print val
      return "insertion reussie"
           

connectionInfos :: ConnectInfo
connectionInfos = ConnectInfo "localhost" 3306  "root" "Borice1999#" "geslabo" [] "" Nothing