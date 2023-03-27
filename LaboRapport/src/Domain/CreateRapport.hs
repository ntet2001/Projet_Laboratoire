
module Domain.CreateRapport where

    import Common.SimpleTypes
    import Data.Time
    import Control.Monad.IO.Class


    {-===== Function of the Domain to create a Repport that take only the idFiche =====-}



    createRapport :: Fiche -> Int -> IO Rapport
    createRapport fiche idrapport =  do
        dateAct <- getCurrentTime
        let contenu = []
        return $ createRapportHelper idrapport contenu fiche dateAct dateAct
              

    createRapportHelper :: Int -> [Int] -> Fiche -> UTCTime -> UTCTime -> Rapport 
    createRapportHelper = MkRapport


    -- fonction pour changer la fiche dans un rapport 

    changeFicheIntoReport :: Rapport -> Fiche -> Rapport 
    changeFicheIntoReport rapport unefiche = 
        let a = idRapport rapport
            b = contenu rapport 
            c = fiche rapport
            d = dateCreatedRapport rapport
            e = dateUpdatedRapport rapport 
        in createRapportHelper a b unefiche d e