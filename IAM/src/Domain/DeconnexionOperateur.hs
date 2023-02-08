module Domain.DeconnexionOperateur where

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
    deconnectOperator :: Matricule -> PasswordOp -> IO ()
    deconnectOperator mat pass = do 
        let newMat = verificationMatricule mat
            newPass = verificationPassword pass
        case newMat of 
            Left errMat -> putStrLn "Matricule incorrect"
            Right mat1 -> do 
                op <- readAOperator mat1
                case op of
                    [] -> putStrLn []
                    xs -> do 
                        case newPass of 
                            Left errPass -> putStrLn "Mot de passe incorrect"
                            Right pass1 -> do
                                let opFinal = head xs
                                    nom = nomOp opFinal
                                    prenom = prenomOp opFinal
                                    email1 = email opFinal
                                    photo1 = photo opFinal
                                    statut = Deconnecter 
                                if passwordOp opFinal == pass1 then
                                    updateOperator nom prenom mat1 email1 pass1 photo1 statut
                                else
                                    putStrLn "Echec de connexion"