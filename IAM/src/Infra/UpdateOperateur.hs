module Infra.UpdateOperateur where

    {------------------------------==== Module importation ====-----------------------------------}
    import qualified Common.SimpleType as ST 
    import System.IO
    import System.Environment


    {-------------------==== Function to take operators in my file ====-----------------------}
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
    resave :: [ST.Operateur] -> IO ()
    resave [] = do
        return ()
    resave ops = do 
        let liste = (unlines $ fmap show ops)
        writeFile "SaveOperateur.txt" liste

    {-----------------------------==== Function to update an Operator ====-------------------------}
    modificationOp :: ST.NomOp -> ST.NomOp -> ST.Matricule -> ST.Email -> ST.PasswordOp -> ST.Photo -> IO ()
    modificationOp nom prenom mat mail pass image = do
        handle <- openFile "SaveOperateur.txt" ReadMode
        contents <- contenuOp handle
        let contenu2 = fmap read contents :: [ST.Operateur]
            contenu3 = fmap (\x -> if mat == ST.matricule x then x { ST.nomOp = nom, ST.prenomOp = prenom, ST.matricule = mat, ST.email = mail, ST.passwordOp = pass, ST.photo = image } else x) contenu2
        hClose handle
        resave contenu3