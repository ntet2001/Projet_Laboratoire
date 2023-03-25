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



    -- founction to get a patient with the given name 

    readByName :: String -> IO Patient 
    readByName oneName = do 
        handle <- openFile "patient.txt" ReadMode
        contents <- contenuOp handle
        if null oneName then fail "le nom ne doit pas etre nul"
        else do
            let contenu2 = fmap read contents :: [Patient]
                someList = [patient | patient <- contenu2, oneName == (nameOf patient ++ " " ++ firstNameOf patient)]
            if null someList then fail $ oneName ++ " ne correspond a aucun patient"
            else return $ head someList

