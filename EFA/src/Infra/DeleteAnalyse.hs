{-# LANGUAGE OverloadedStrings, BangPatterns, DataKinds #-}
{-# LANGUAGE FlexibleInstances, FlexibleContexts  #-}
module Infra.DeleteAnalyse where

import Servant
import Common.SimpleTypes
import Domain.CreateAnalyse
import App.CommonVerification
import Data.Aeson (ToJSON, FromJSON)
import Database.MySQL.Simple
import Database.MySQL.Simple.Types
import Control.Monad.IO.Class (liftIO)

deleteAnal :: String -> IO ()
deleteAnal ida = do
      conn <- connect connectionInfos
      val <- execute conn ("delete from analyses where idAnalyse = ?") (Only ida) 
      print val     

connectionInfos :: ConnectInfo
connectionInfos = ConnectInfo "localhost" 3306  "root" "Borice1999#" "geslabo" [] "" Nothing      