module Domain.ConnexionPatient where

    {-------------------------==== Module Importation ====---------------------------------------}
    import Text.Parsec
    import Text.ParserCombinators.Parsec
    import Text.ParserCombinators.Parsec.Language()
    import Common.SimpleType 
    import App.CommonVerification
    import Infra.ReadPatient
    import Infra.UpdatePatient
    import Domain.DomPatient
    import App.AppPatient
    
    {-------------------------==== Function to connect a Patient ====--------------------------------}
    connectPatient :: Int -> Nom -> IO()
    connectPatient code nom = do 
        let newCode = verifCode code
            newNom = verificationNom nom
        case newCode of 
            Left errCode -> putStrLn "Matricule incorrect"
            Right code1 -> do 
                pat <- readAPatient code1
                case pat of
                    [] -> putStrLn []
                    xs -> do 
                        case newNom of 
                            Left errPass -> putStrLn "Mot de passe incorrect"
                            Right nom1 -> do
                                let patFinal = head xs
                                    nom = nameOf patFinal
                                    prenom = firstNameOf patFinal
                                    email1 = emailOf patFinal
                                    photo1 = photoOf patFinal
                                    statut = Connecter 
                                if nom == nom1 then
                                    updatePatient code1 nom prenom email1 photo1 statut
                                else
                                    putStrLn "Echec de connexion"