{-# LANGUAGE OverloadedStrings #-}
module App.AppDeleteFiche where

    {-====== importation =========-}
    import Infra.DeleteFiche
    import qualified Network.HTTP.Simple as NT
    import Data.Aeson

    {-===== * Here is my function to delete a fiche
    * this function take in input the id of a fiche 
    * call the endpoints to get a repport 
    * verified that the repport is empty. If true delete the repport and the fiche
    * else do not delete and return a message the repport already have content =====-}
    appDeleteFiche :: Int -> IO String
    appDeleteFiche idFiche = do 
        request <- NT.parseRequest ("http://localhost:8082/rapports/contenus/" ++ show idFiche)
        response <- NT.httpJSON request :: IO (NT.Response Value)
        let resultat =  NT.getResponseBody response
        case resultat of 
            Array x -> 
                if null x then do 
                    request <- NT.parseRequest ("DELETE http://localhost:8082/rapports/" ++ show idFiche)
                    response <- NT.httpJSON request :: IO (NT.Response Value)
                    deleteFiche idFiche
                else
                    return "Can't delete the repport already have content"