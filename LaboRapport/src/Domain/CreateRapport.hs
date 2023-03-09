
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