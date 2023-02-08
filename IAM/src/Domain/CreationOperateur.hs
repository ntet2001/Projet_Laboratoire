module Domain.CreationOperateur where

    {-------------------------==== Module Importation ====---------------------------------------}
    import Text.Parsec
    import Text.ParserCombinators.Parsec
    import Text.ParserCombinators.Parsec.Language()
    import Common.SimpleType 
    import App.CommonVerification 
    import Data.Char
    import Infra.SaveOperateur

    {--------------------------==== Function to validated a Matricule ====----------------------------------}
    verificationMatricule :: String -> Either ParseError Matricule -- a Refaire
    verificationMatricule matricule = parse parserMatricule "" matricule
        where parserMatricule = do
                            mat <- many alphaNum
                            case null mat of
                                True -> unexpected "matricule vide"
                                False -> return mat

    {---------------------===== Function to validate a Password =====----------}
    parserPassword :: Parser String
    parserPassword = do
        input <- many anyChar
        case (length input) >= 8 of
            False -> unexpected "le mot de passe doit avoir au moins 8 caracteres!"
            True -> do
                let l1 = filter isUpper input
                    l2 = filter isLower input
                    l3 = filter (`elem` "@$^!#%&*()/?<>|[]{}'+-_=`~.") input
                    size = map length [l1, l2, l3]
                case and $ map (>= 1) size of
                    False -> unexpected "le mot de passe doit avoir au moins une majuscule, une minuscule et un caractere special"
                    True -> return input

    verificationPassword :: String -> Either ParseError  PasswordOp
    verificationPassword mdp = parse parserPassword "" mdp

    {---------------------===== Function to Create an Operator =====----------}
    createOperator :: NomOp -> PrenomOp -> Matricule -> String -> PasswordOp -> String -> Either ParseError Operateur
    createOperator nom prenom matricule email password photo = MKOperateur <$> 
        verificationNom nom <*> 
        verificationNom prenom <*> 
        verificationMatricule matricule <*> 
        verificationEmail email <*> 
        verificationPassword password <*> 
        verificationPhoto photo <*>
        verificationStatut "Aucun"