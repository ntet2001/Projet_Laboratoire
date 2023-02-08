module Infra.ReadOperateur where

    {---------------------------==== Module importation ====--------------------------------}
    import Common.SimpleType
    import Domain.CreationOperateur (verificationMatricule) 
    import System.IO
    import System.Environment
    import Infra.FunctionsInfra

    {-------------------==== Function declaration of Read Operators ====---------------------}
    
    readOperator :: IO [Operateur]
    readOperator  = do
        contenu <- readFile "SaveOperateur.txt"
        let contenu1 = lines contenu
            contenu2 = fmap read contenu1 :: [Operateur]
            contenu3 = filter (\x -> (statutOp x == Aucun) || (statutOp x == Deconnecter) || (statutOp x == Connecter)) contenu2 
        if null contenu3 then 
            return []
        else 
            return contenu3

    {-------------------==== Function declaration of Read an Operators ====---------------------}
    
    readAOperator :: String -> IO [Operateur]
    readAOperator mat = do
        handle <- openFile "SaveOperateur.txt" ReadMode
        contents <- contenuOp handle
        let resultatMatricule = verificationMatricule mat
        case resultatMatricule of 
            Left _ -> return []
            Right mat1 -> do
                let contenu2 = fmap read contents :: [Operateur]
                    contenu3 = filter (\x -> ((statutOp x == Aucun) || (statutOp x == Deconnecter) || (statutOp x == Connecter) ) && (mat == matricule x)) contenu2 
                if null contenu3 then 
                    return []
                else do
                    hClose handle
                    return contenu3