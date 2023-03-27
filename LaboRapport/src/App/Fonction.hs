module App.Fonction where

import Domain.CreateAnalyse (createAnalyse', verifValUsuel, verifCategorie)
import Infra.SaveAnalyse (saveAnalyse)
import Common.SimpleTypes
import Control.Monad (Monad(return))
import System.IO.Error


{- verifications au niveau applicatif : verifier que les parametres 
d'entre ne  sont pas vides-}

save :: String -> String -> String -> IO String
save nom value somecategory = do
    if null nom || null value || null somecategory 
        then fail "les parametres d'entree ne doivent pas etre vides"
    else do 
        let checkedValue = verifValUsuel value
        case checkedValue of
            Left msg1 -> fail $ msg1 ++ ": " ++ show value
            Right someValue -> do 
                let checkedCategorie = verifCategorie somecategory
                case checkedCategorie of 
                    Left msg2 -> fail $ msg2 ++ ": " ++ show somecategory
                    Right someCategorie -> do
                        let identifiant = "A-" ++ take 3 (nom)
                            result = createAnalyse' identifiant nom someValue someCategorie
                        saveAnalyse result
                        return "Analyse enregistree avec success"

    --         something = createAnalyse identifiant nom (read value :: ValUsuel) (read somecategory :: Categorie)
    -- case something of
    --     Right someAnalyse -> do 
    --         saveAnalyse someAnalyse
    --         return someAnalyse
    --     Left msg -> fail msg

-- save' :: String -> String -> String -> String -> IO Analyse
-- save' identifiant nom value somecategory = undefined