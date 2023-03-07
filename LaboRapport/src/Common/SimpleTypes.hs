{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Common.SimpleTypes where 

    import Data.Time
    import Data.Aeson
    import Data.Aeson.TH
    
    type IdResult = Int 

    data InfoPatient = MkPatient { 
        nom :: String,
        prenom :: String,
        annee :: Int,
        genre :: String, 
        email :: String
    } deriving (Show, Eq, Read, Generic)
    $(deriveJSON defaultOptions ''InfoPatient)

    data LineResult = Negatif String | Positif String Float 
    $(deriveJSON defaultOptions ''LineResult)

    data Rapport = MkRapport { idRapport :: Int,
        contenu :: [IdResult],
        idFiche :: Int
    }
    $(deriveJSON defaultOptions ''Rapport)

    data Resultat = MkResult { idResult :: Int,
        idAnal :: Int,
        interpretation :: String,
        conclusion :: String,
        infoPat :: InfoPatient,
        prelevement :: UTCTime,
        prescripteur :: String,
        numDossier :: Int,
        lineResults :: [LineResult],
        nomLaborantin :: String
    }
    $(deriveJSON defaultOptions ''Resultat)
