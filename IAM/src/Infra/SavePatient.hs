module Infra.SavePatient where

    {----------------------===== Importations =====-----------------------------}
    import Common.SimpleType
    import System.IO
    import System.Environment

    {-------------------- ====== function to verified if a patient already exist ====== ----------------}
    verifPatient :: Patient -> String -> IO (Either String Patient) 
    verifPatient inputPatient nameFile = do
        contient <- readFile nameFile 
        let ligneParligne = lines contient
            convertToPatient = fmap read ligneParligne :: [Patient]
            --listInfosPatient = map infos convertToPatient :: [InfoPatient]
            var = emailOf inputPatient 
            emailOfPatient = fmap emailOf convertToPatient
            listeEmail = filter (== var)  emailOfPatient
        if null listeEmail then return $ Right inputPatient
        else return $ Left "ce patient existe deja !!"

    {-------------------- ====== function to save patient ====== ----------------}
    savePatient :: Patient -> IO ()
    savePatient pt = do 
        var <- verifPatient pt "patient.txt"
        case var of 
            Right something -> appendFile "patient.txt" (show something ++ "\n")
            Left _ -> return ()