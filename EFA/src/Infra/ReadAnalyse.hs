{-# LANGUAGE OverloadedStrings, BangPatterns, DataKinds #-}
{-# LANGUAGE FlexibleInstances, FlexibleContexts  #-}
module Infra.ReadAnalyse where
import Servant
import Common.SimpleTypes
import Domain.CreateAnalyse
import App.CommonVerification
import Data.Aeson (ToJSON, FromJSON)
import Database.MySQL.Simple
import Database.MySQL.Simple.Types
import Control.Monad.IO.Class (liftIO)


readAnals :: IO [Analyse]
readAnals = do
      conn <- connect connectionInfos
      query_ conn "select * from analyses"


connectionInfos :: ConnectInfo
connectionInfos = ConnectInfo "localhost" 3306  "root" "Borice1999#" "geslabo" [] "" Nothing      