module Infra.UpdatePatient where

    {----------------------===== Importations =====-----------------------------}
    import Common.SimpleType
    import System.IO
    import System.Environment
    import Infra.FunctionsInfra
    import App.AppPatient
    import App.CommonVerification
    import Text.Parsec
    
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

    

    -- patient update by name : seuls le nom , le prenom , l'email sont mis a jour
        -- il y aura un endpoint pour la mis de la photo apres.
        -- car dans les donnees qui viennent a IAM lors de la mis a jour de la fiche il y a pas la photo

    updateByName :: String -> String -> String -> String -> IO String
    updateByName someName newName newPrenom newMail = do
        handle <- openFile "patient.txt" ReadMode
        contents <- contenuOp handle
        if null someName  then return " le nom du patient doit avoir au moins deux caracteres "
        else do 
            let contenu2 = fmap read contents :: [Patient]
                someList = [patient | patient <- contenu2, someName == (nameOf patient ++ " " ++ firstNameOf patient)]
            if null someList then return $ someName ++ " ne correspond a aucun patient"
            else do 
                let areCorrect = checkedNewParams newName newPrenom newMail 
                case areCorrect of 
                    Left _      -> return "les nouveaux parametres du patient ne sont pas corrects"
                    Right (x,y,z) -> do 
                        let newPatient = MkPatient x y z (photoOf $ head someList) (code $ head someList) (statutP $ head someList)
                            updateListOfPatient = change someName newPatient contenu2
                        resavePatient updateListOfPatient
                        return $ "le patient dont le nom est " ++ someName ++ " a ete mis a jour"

                        where change :: String -> Patient -> [Patient] -> [Patient]
                              change _ _ [] = []
                              change oneName updatedPatient (onePat:manyPat) = 
                                if oneName == (nameOf onePat ++ " " ++ firstNameOf onePat) then updatedPatient:manyPat
                                else onePat : change oneName updatedPatient manyPat

                    -- fonction qui verifie les nouveaux parametres avant mis a jour 
    checkedNewParams :: String -> String -> String -> Either ParseError (Nom,Nom,Email)
    checkedNewParams a b c = (,,) <$> verificationNom a <*>
                                      verificationNom b <*>
                                      verificationEmail c

                               

