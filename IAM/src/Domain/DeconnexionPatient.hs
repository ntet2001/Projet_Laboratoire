module Domain.DeconnexionPatient where

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
    deconnectPatient :: Int -> Nom -> IO String
    deconnectPatient code nom = do 
        let newCode = verifCode code
            newNom = verificationNom nom
        case newCode of 
            Left errCode -> return "Code incorrect"
            Right code1 -> do 
                pat <- readAPatient code1
                case pat of
                    [] -> return "le Patient n'existe pas"
                    xs -> do 
                        case newNom of 
                            Left errPass -> return "Le Nom est invalide"
                            Right nom1 -> do
                                let patFinal = head xs
                                    nom = nameOf patFinal
                                    prenom = firstNameOf patFinal
                                    email1 = emailOf patFinal
                                    photo1 = photoOf patFinal
                                    statut = Deconnecter 
                                if (nom ++ " " ++ prenom) == nom1 then
                                    do 
                                        updatePatient code1 nom prenom email1 photo1 statut
                                        return "Deconnected"
                                else
                                    return "Echec de connexion le nom n'existe pas"