module Infra.UpdateOperateur where

    {------------------------------==== Module importation ====-----------------------------------}
    import Common.SimpleType
    import Domain.CreationOperateur (verificationMatricule)
    import System.IO
    import System.Environment
    import Infra.FunctionsInfra

    {-----------------------------==== Function to update an Operator ====-------------------------}
    updateOperator :: NomOp -> NomOp -> Matricule -> Email -> PasswordOp -> Photo -> Statut -> IO ()
    updateOperator nom prenom mat mail pass image statu = do 
        handle <- openFile "SaveOperateur.txt" ReadMode
        contents <- contenuOp handle
        let resultatMatricule = verificationMatricule mat
        case resultatMatricule of 
            Left _ -> putStrLn "Matricule non valide"
            Right mat1 -> do 
                let contenu2 = fmap read contents :: [Operateur]
                    contenu3 = fmap (\x -> if mat1 == matricule x then MKOperateur nom prenom mat1 mail pass image statu else x) contenu2
                hClose handle
                resaveOperator contenu3 