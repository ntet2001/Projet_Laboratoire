module Infra.SaveOperateur where

    {---------------------------==== Module importation ====--------------------------------}
    import Common.SimpleType 
    import System.IO
    import System.Environment
    

    {---------------------------==== Function to verified if an Operator exist ====--------------------------------}
    verificationOp :: Operateur -> String -> IO (Either String Operateur)
    verificationOp op path = do
        contenu <- readFile path
        let contenu1 = lines contenu
            matricule1 = matricule op 
            contenu1filtre = filter (== matricule1) contenu3
            contenu2 = fmap read contenu1 :: [Operateur]
            contenu3 = fmap matricule contenu2 
        if null contenu1filtre then 
            return $ Right op 
        else 
            return $ Left $ "le matricule appartient a" ++ show contenu1filtre

    {---------------------------==== Function to register an Operator ====--------------------------------}

    saveOperator :: Operateur -> IO ()
    saveOperator op = do
        let op1 = verificationOp op "SaveOperateur.txt"
        op <- op1
        case op of
            Left a -> print a
            Right b -> appendFile "SaveOperateur.txt" (show b ++ "\n")


