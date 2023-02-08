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
    connectOperator :: Matricule -> PasswordOp -> IO ()
    connectOperator mat pass = do 
        let newMat = verificationMatricule mat
            newPass = verificationPassword pass
        case newMat of 
            Left errMat -> putStrLn "Matricule incorrect"
            Right mat1 -> do 
                op <- readAOperator mat1
                case op of
                    [] -> putStrLn "pas d'operateur"
                    xs -> do 
                        case newPass of 
                            Left errPass -> putStrLn "Mot de passe incorrect"
                            Right pass1 -> do
                                let opFinal = head xs
                                    nom = nomOp opFinal
                                    prenom = prenomOp opFinal
                                    email1 = email opFinal
                                    photo1 = photo opFinal
                                    statut = Connecter
                                    passf = passwordOp opFinal 
                                if passwordOp opFinal == pass1 then
                                    updateOperator nom prenom mat1 email1 passf photo1 statut
                                else
                                    putStrLn "Echec de connexion"


    
