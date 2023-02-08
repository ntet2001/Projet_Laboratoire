module Infra.FunctionsInfra where

    {------------------------------==== Module importation ====-----------------------------------}
    import System.IO
    import System.Environment
    import Common.SimpleType

    {-------------------==== Function to take an Operator Or Patient in my file ====-----------------------}
    contenuOp :: Handle -> IO [String]
    contenuOp h = do
        val <- hIsEOF h
        if val
            then do
                return []
            else do
                pa <- hGetLine h
                rest <- contenuOp h
                return (pa : rest)

    {--------------------------==== Function to resave operators ====-----------------------}
    resaveOperator :: [Operateur] -> IO ()
    resaveOperator [] = do
        return ()
    resaveOperator ops = do 
        let liste = (unlines $ fmap show ops)
        writeFile "SaveOperateur.txt" liste

    {--------------------------==== Function to resave Patient ====-----------------------}
    resavePatient :: [Patient] -> IO ()
    resavePatient [] = do
        return ()
    resavePatient ops = do 
        let liste = (unlines $ fmap show ops)
        writeFile "patient.txt" liste