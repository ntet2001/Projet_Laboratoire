module App.Fonction where

import Domain.CreateAnalyse (createAnalyse)
import Infra.SaveAnalyse (saveAnalyse)



save :: String -> String -> String -> String -> IO ()
save identifiant nom value somecategory = do
    let something = createAnalyse identifiant nom value somecategory
    case something of
        Right someAnalyse -> saveAnalyse someAnalyse
        Left msg -> fail msg

