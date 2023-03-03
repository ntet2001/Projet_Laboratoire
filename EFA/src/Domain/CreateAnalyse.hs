module Domain.CreateAnalyse where

import Common.SimpleTypes


--- verifications propres au domaine : categorie et la valeur 

-- verification de la categorie
verifCategorie :: String -> Either String Categorie
verifCategorie something = do
    case something of
        "Biochimie" -> Right Biochimie
        "Hematologie" -> Right Hematologie
        "Serologie" -> Right Serologie
        "Parasitologie" -> Right Parasitologie
        _ -> Left "cet valeur ne correspond pas à une categorie valide"

-- verification de la valeur usuelle

verifValUsuel :: String -> Either String ValUsuel
verifValUsuel someValue = do
    case someValue of
        "Vide" -> Right Vide
        something -> do
            let firstStep = fUneVal something
            case firstStep of 
                Right typeValUsuel -> return $ UneVal typeValUsuel
                Left _ -> do 
                    let secondStep = fInterval something
                    case secondStep of
                        Right (i,j) -> return $ Interval i j
                        Left _ -> Left "cet element n'est pas de type ValUsuel"

-- verification generale : nomAnalyse, idAnalyse

verifString :: String -> Either String String
verifString str = 
    if null str then Left "erreur, inserer une valeur" else return str
    
    
-- fonction pour creer une analyse

createAnalyse :: IdAnalyse -> String -> String -> String -> Either String Analyse 
createAnalyse someId someValue category someName = 
    MkAnalyse <$> verifString someId <*>
                  verifString someName <*>
                  verifValUsuel someValue <*>
                  verifCategorie category



