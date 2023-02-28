module Main (main) where

import Lib
import Common.SimpleTypes
import Data.Time
import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Common.SimpleTypes
import Infra.SaveAnalyse
import Common.SimpleTypes
import Domain.CreateAnalyse
import App.CommonVerification
-- import Data.Aeson (ToJSON, FromJSON)
import Database.MySQL.Simple
import Database.MySQL.Simple.Types
import Control.Monad.IO.Class (liftIO)
import Infra.DeleteAnalyse
import Infra.ReadAnalyse
import Infra.SaveAnalyse
import Infra.UpdateAnalyse
import Common.SimpleTypes
--import Data.Dates

main :: IO ()
main = startApp
