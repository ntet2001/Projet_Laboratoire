{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Common.SimpleTypes where 

    import Data.Time
    import Data.Aeson
    import Data.Aeson.TH

    data InfoPatient = MkPatient { 
        nom :: String,
        prenom :: String,
        datenaissance :: Int,
        genre :: String, 
        email :: String
    } deriving (Show, Eq, Read, Generic)
    $(deriveJSON defaultOptions ''InfoPatient)

    data Resultat = MkResult {
        idResult :: Int ,
        idAnalyse :: Int,
        interpretation :: String,
        conclusion :: String ,
        infoPatient :: InfoPatient,
        datePrelevement :: UTCTime,
        prescripteur :: String,
        nomLaborantin :: String,
        results :: [lineResult]
    }