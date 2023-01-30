module Infra.DeleteOperateur where

    {---------------------------==== Module importation ====--------------------------------}
    import qualified Common.SimpleType as ST 
    import System.IO
    import System.Environment

    {-------------------==== Function to take operators in my file ====-----------------------}
    contenuPa :: Handle -> IO [String]
    contenuPa h = do
        val <- hIsEOF h
        if val
            then do
                return []
            else do
                pa <- hGetLine h
                rest <- contenuPa h
                return (pa : rest)

    {--------------------------==== Function to resave operators ====-----------------------}
    resave :: [ST.Operateur] -> IO ()
    resave [] = do
        return ()
    resave ops = do 
        let liste = (unlines $ fmap show ops)
        writeFile "SaveOperateur.txt" liste

    {----------------------------==== function to delete an Operator ====-------------------}
    supprimerOp :: String -> IO ()
    supprimerOp mat = do
        handle <- openFile "SaveOperateur.txt" ReadMode
        contents <- contenuPa handle
        let contenu2 = fmap read contents :: [ST.Operateur]
            contenu3 = fmap (\x -> if mat == ST.matricule x then x {ST.statutOp = ST.Supprimer} else x) contenu2
        hClose handle
        resave contenu3