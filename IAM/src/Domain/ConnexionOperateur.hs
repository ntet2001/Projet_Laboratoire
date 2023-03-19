module Domain.ConnexionOperateur where

    {-------------------------==== Module Importation ====---------------------------------------}
    import Text.Parsec
    import Text.ParserCombinators.Parsec
    import Text.ParserCombinators.Parsec.Language()
    import Common.SimpleType 
    import App.CommonVerification
    import Infra.ReadOperateur
    import Infra.UpdateOperateur
    import Domain.CreationOperateur

    {-------------------------==== Function to connect an Operator ====--------------------------------}
    connectOperator :: Matricule -> PasswordOp -> IO String
    connectOperator mat pass = do 
        let newMat = verificationMatricule mat
            newPass = verificationPassword pass
        case newMat of 
            Left errMat -> return "Matricule incorrect"
            Right mat1 -> do 
                op <- readAOperator mat1
                case op of
                    [] -> return "l'operateur n'existe pas"
                    xs -> do 
                        case newPass of 
                            Left errPass -> return "Mot de passe invalide"
                            Right pass1 -> do
                                let opFinal = head xs
                                    nom = nomOp opFinal
                                    prenom = prenomOp opFinal
                                    email1 = email opFinal
                                    photo1 = photo opFinal
                                    statut = Connecter
                                    passf = passwordOp opFinal 
                                if passwordOp opFinal == pass1 then
                                    do
                                        updateOperator nom prenom mat1 email1 photo1 statut
                                        return "Connected"
                                else
                                    return "Echec de connexion le mot de passe n'existe pas"


    
