
module Domain.CreateRapport where

    import Common.SimpleTypes
    import Data.Time
    import Control.Monad.IO.Class


    {-===== Function of the Domain to create a Repport that take only the idFiche =====-}



    createRapport :: Int -> IO Rapport
    createRapport idFiche =  do
        dateAct <- getCurrentTime
        let idrapport = 0
            contenu = []
        return $ createRapportHelper idrapport contenu idFiche dateAct dateAct
              

    createRapportHelper :: Int -> [Int] -> Int -> UTCTime -> UTCTime -> Rapport 
    createRapportHelper = MkRapport