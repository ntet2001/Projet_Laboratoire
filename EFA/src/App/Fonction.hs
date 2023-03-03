module App.Fonction where

import Domain.CreateAnalyse (createAnalyse)
import Infra.SaveAnalyse (saveAnalyse)
import Common.SimpleTypes
import Control.Monad (Monad(return))


save :: String -> String -> String -> String -> IO Analyse
save identifiant nom value somecategory = do
    let something = createAnalyse identifiant nom value somecategory
    case something of
        Right someAnalyse -> do 
            saveAnalyse someAnalyse
            return someAnalyse
        Left msg -> fail msg

