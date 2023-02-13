module Infra.ReadPatient where 

    {---------------------------==== Module importation ====--------------------------------}
    import Common.SimpleType
    import App.AppPatient
    import System.IO
    import System.Environment
    import Infra.FunctionsInfra



    {-------------------==== Function to read patients ====---------------------}
    
    readPatient :: IO [Patient]
    readPatient  = do
        contenu <- readFile "patient.txt"
        let contenu1 = lines contenu
            contenu2 = fmap read contenu1 :: [Patient]
            contenu3 = filter (\x -> (statutP x == Aucun) || (statutP x == Deconnecter) || (statutP x == Connecter)) contenu2 
        if null contenu3 then 
            return []
        else 
            return contenu3


    {------------------------============ Function to read a patient ====---------------------}

    readAPatient :: Int -> IO [Patient]
    readAPatient codeAccess = do
        handle <- openFile "patient.txt" ReadMode
        contents <- contenuOp handle
        let resultatCode = verifCode codeAccess
        case resultatCode of 
            Left _ -> return []
            Right code1 -> do
                let contenu2 = fmap read contents :: [Patient]
                    contenu3 = filter (\x -> (statutP x == Aucun || (statutP x == Deconnecter) || (statutP x == Connecter)) && (code1 == code x)) contenu2 
                if null contenu3 then 
                    return []
                else do
                    hClose handle
                    return contenu3

   

    -- found a patient with the access code given 

    foundPatient :: AccessCode -> IO Patient 
    foundPatient someCode = do
        fileContent <- readFile "patient.txt"
        let linePerline = lines fileContent
            toPa = fmap read linePerline :: [Patient]
            liste = [patient | patient <- toPa, code patient == someCode]
        if null liste then fail "ce code ne correspond a aucun patient enregistré"
        else return $ head liste 