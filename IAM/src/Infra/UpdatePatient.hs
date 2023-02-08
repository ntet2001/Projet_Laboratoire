module Infra.UpdatePatient where

    {----------------------===== Importations =====-----------------------------}
    import Common.SimpleType
    import System.IO
    import System.Environment
    import Infra.FunctionsInfra
    import App.AppPatient

    {----------------------------==== function to update a patient ====-------------------}
    updatePatient :: Int -> NomPatient -> PrenomPatient -> Email -> Photo -> Statut -> IO ()
    updatePatient accessCode newName newPrenom newEmail newPhoto statu= do
        handle <- openFile "patient.txt" ReadMode
        contents <- contenuOp handle
        let resultatCode = verifCode accessCode
        case resultatCode of 
            Left _ -> putStrLn "Code non valide"
            Right code1 -> do 
                let contenu2 = fmap read contents :: [Patient]
                    contenu3 = fmap (\x -> if code1 == code x then x { nameOf = newName, firstNameOf = newPrenom, code = code1, emailOf = newEmail, photoOf = newPhoto, statutP = statu } else x) contenu2
                hClose handle
                resavePatient contenu3 