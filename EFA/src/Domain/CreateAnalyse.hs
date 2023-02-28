module Domain.CreateAnalyse where

import App.CommonVerification
import Common.SimpleTypes


createAnalyse :: IdAnalyse -> NomAnalyse -> ValUsuel -> Categorie -> Either String Analyse
createAnalyse idAnal nomAnal valUsuel cat =
    MkAnalyse <$>
    verifNom idAnal <*>
    verifNom nomAnal <*>
    verifVal valUsuel <*>
    verifCat cat


