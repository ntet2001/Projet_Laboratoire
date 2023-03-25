module Infra.DeletePatient where

    {---------------------------==== Module importation ====--------------------------------}
    import Common.SimpleType  
    import System.IO
    import System.Environment
    import Infra.FunctionsInfra


    {------------------------======== Function to delete a Patient ====---------------------}
    deletePatient :: Int -> IO ()
    deletePatient accessCode = do
        handle <- openFile "patient.txt" ReadMode
        contents <- contenuOp handle
        let contenu2 = fmap read contents :: [Patient]
            contenu3 = fmap (\x -> if accessCode == code x then x { statutP = Supprimer } else x) contenu2
        hClose handle
        resavePatient contenu3

-- function to delete a patient with his given name

    deleteByName :: String -> IO String 
    deleteByName someName = do
        handle <- openFile "patient.txt" ReadMode
        contents <- contenuOp handle
        let contenu2 = fmap read contents :: [Patient]
            contenu3 = fmap (\x -> if someName == (nameOf x ++ " " ++ firstNameOf x) then x { statutP = Supprimer } else x) contenu2
        hClose handle
        resavePatient contenu3
        return $ "le statur de " ++ someName ++ " est" ++ " Supprimer"
