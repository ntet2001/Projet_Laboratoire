{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}
{-# OPTIONS_GHC -Wno-unused-local-binds #-}

module Infra.InfraPatient where 

import Common.SimpleType
import App.AppPatient
import Domain.DomPatient
import Data.List
import System.IO


-- fonction pour creer un patient 

savePatient :: Patient -> IO ()
savePatient pt = do 
    var <- verifPatient pt "patient.txt"
    case var of 
        Right something -> appendFile "patient.txt" (show something ++ "\n")
        Left _ -> return ()

-- fonction pour lire un patient, dans un fichier   
readPatient :: Int -> String -> IO Patient
readPatient codeAccess fileName = do
    --let checkedCode = verifCode codeAccess 
    --case checkedCode of 
        --Right someStuff -> do 
    contenuFichier <- readFile fileName
    let ligneParLigne = lines contenuFichier
        convertToPatient = fmap read ligneParLigne :: [Patient]
        liste = [x | x <- convertToPatient,  length (filter (== codeAccess) [code x]) == 1]
    if null liste then fail "le code ne correspond à aucun patient"
    else return $ head liste 
        --Left _ -> fail  "le code n'est pas valide"

-- fonction supprimer un patient, dans un fichier

deletePatient :: Int -> String -> IO ()
deletePatient accessCode fileName = do
    -- let codeVerifie = verifCode accessCode 
    --case codeVerifie of 
        --Right someCode -> do
    fileContent <- readFile fileName
    let linePerline = lines fileContent
        toPatient = fmap read linePerline :: [Patient]
        updateListOfPatient = f accessCode toPatient
    if null updateListOfPatient then fail "ce code ne correspond à aucun patient"
    else  do 
        let mapShow = fmap show updateListOfPatient 
            var = unlines mapShow
        writeFile fileName var 
        --Left _ -> fail "le code d'acces n'est pas valide"  
    where f :: Int -> [Patient] -> [Patient]
          f _ [] = []
          f patientCode (x:xs)
            | code x == patientCode = xs 
            | otherwise = x : f patientCode xs 


-- fonction pour mettre a jour un patient 

updatePatient :: Int -> String -> NomPatient -> PrenomPatient -> String -> String -> IO ()
updatePatient accessCode fileName newName newPrenom newEmail newPhoto = do
    handleFile <- openFile fileName ReadWriteMode
    fileContent <- contenuPa handleFile 
    hClose handleFile
    let --linePerline = lines fileContent 
        toPatient =  fmap read fileContent :: [Patient]
        (indice:_) = elemIndices accessCode $ fmap code toPatient
        newPatient = createHelper newName newPrenom newEmail newPhoto accessCode
    case newPatient of 
            Right something -> do 
                let (xs , ys) = Data.List.splitAt (indice +1) toPatient
                    showSomething = show something 
                --print (xs , ys, indice)
                if null xs then do 
                    let (h:hs) = ys 
                    --hPutStrLn handleFile $ unlines $ showSomething : f hs 
                    writeFile fileName $ unlines $ showSomething : f hs
                    --hClose handleFile
                else  do 
                    let withoutLast = init $ f xs
                    --hPutStrLn handleFile $ unlines $ withoutLast ++ (showSomething : f ys)
                    writeFile fileName $ unlines $ withoutLast ++ (showSomething : f ys)
                    --hClose handleFile
                where f :: [Patient] -> [String]     
                      f =  fmap show 
            Left _ -> fail "les parametres sont errones"

-- fonction pour recuperer le contenu du fichier avec une recursion de getLine 

contenuPa :: Handle -> IO [String]
contenuPa h = do
    val <- hIsEOF h
    if val
        then return []
        else do
            pa <- hGetLine h
            rest <- contenuPa h
            --hClose h
            return (pa : rest)
            