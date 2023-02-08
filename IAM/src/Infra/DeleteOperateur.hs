module Infra.DeleteOperateur where

    {---------------------------==== Module importation ====--------------------------------}
    import Common.SimpleType
    import System.IO
    import System.Environment
    import Infra.FunctionsInfra

    {----------------------------==== function to delete an Operator ====-------------------}
    deleteOperator :: String -> IO ()
    deleteOperator mat = do
        handle <- openFile "SaveOperateur.txt" ReadMode
        contents <- contenuOp handle
        let contenu2 = fmap read contents :: [Operateur]
            contenu3 = fmap (\x -> if mat == matricule x then x {statutOp = Supprimer} else x) contenu2
        hClose handle
        resaveOperator contenu3