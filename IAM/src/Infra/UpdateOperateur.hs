module Infra.UpdateOperateur where

    {------------------------------==== Module importation ====-----------------------------------}
    import Common.SimpleType
    import Domain.CreationOperateur (verificationMatricule)
    import System.IO
    import System.Environment
    import Infra.FunctionsInfra

    {-----------------------------==== Function to update an Operator ====-------------------------}
    updateOperator :: NomOp -> NomOp -> Matricule -> Email -> Photo -> Statut -> IO String
    updateOperator nom prenom mat mail image statu = do 
        handle <- openFile "SaveOperateur.txt" ReadMode
        contents <- contenuOp handle
        let resultatMatricule = verificationMatricule mat
        case resultatMatricule of 
            Left _ -> return "Matricule non valide"
            Right mat1 -> do 
                let contenu2 = fmap read contents :: [Operateur]
                    contenu3 = fmap (\x -> if mat1 == matricule x then MKOperateur nom prenom mat1 mail (passwordOp x) image statu else x) contenu2
                hClose handle
                resaveOperator contenu3 
                return "Updated successfuly"

    updatePassword :: String -> String -> String -> IO String
    updatePassword oldMdp newMdp mat = do 
        handle <- openFile "SaveOperateur.txt" ReadMode
        contents <- contenuOp handle
        let resultatMatricule = verificationMatricule mat
        case resultatMatricule of 
            Left _ -> return "Matricule non valide"
            Right mat1 -> do 
                let contenu2 = fmap read contents :: [Operateur]
                    contenu3 = fmap (\x -> if oldMdp == passwordOp x then MKOperateur (nomOp x) (prenomOp x) mat1 (email x) newMdp (photo x) (statutOp x) else x) contenu2
                hClose handle
                if contenu3 == contenu2 then 
                    return "ancien mot de passe incorret"
                else 
                    do
                        resaveOperator contenu3 
                        return "Updated Password successful"
