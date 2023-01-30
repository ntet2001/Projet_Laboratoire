module Infra.SaveOperateur where

    {---------------------------==== Module importation ====--------------------------------}
    import qualified Common.SimpleType as ST 
    import System.IO
    import System.Environment
    

    {---------------------------==== Function to verified if an Operator exist ====--------------------------------}
    verificationOp :: ST.Operateur -> String -> IO (Either String ST.Operateur)
    verificationOp op path = do
        contenu <- readFile path
        let contenu1 = lines contenu
            matricule1 = ST.matricule op 
            contenu1filtre = filter (== matricule1) contenu3
            contenu2 = fmap read contenu1 :: [ST.Operateur]
            contenu3 = fmap ST.matricule contenu2 
        if null contenu1filtre then 
            return $ Right op 
        else 
            return $ Left $ "le matricule appartient a" ++ show contenu1filtre

    {---------------------------==== Function to register an Operator ====--------------------------------}

    enregistrerOP :: ST.Operateur -> IO ()
    enregistrerOP op = do
        let op1 = verificationOp op "SaveOperateur.txt"
        op <- op1
        case op of
            Left a -> print a
            Right b -> appendFile "SaveOperateur.txt" (show b ++ "\n")


