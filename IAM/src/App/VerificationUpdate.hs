module App.VerificationUpdate where

    import Infra.UpdateOperateur
    import Common.SimpleType
    import Control.Monad.IO.Class
    import Text.Parsec
    import Domain.CreationOperateur

    --function to verify that not null parameters are send to update an operator

    verifUpdateInfo :: String -> String -> String -> Email -> Photo -> Statut -> IO String
    verifUpdateInfo name lastname mat email photo status = do 
        if null name|| null lastname || null mat  then
             return "remplissez toutes les informations pour mettre a jour un operateur"
        else 
            do
                var <- liftIO $ updateOperator name lastname mat email photo status
                return var

    verifUpdatePass :: String -> String -> String -> IO String
    verifUpdatePass oldPassword newPassword matriculepass = do 
        if null oldPassword|| null newPassword || null matriculepass  then
             return "remplissez toutes les informations pour mettre a jour un mot de passe"
        else 
            do
                let verifiedParam = checkFunction oldPassword newPassword matriculepass 
                case verifiedParam of
                    Left msg -> return $ show msg
                    Right (a,b,c) -> do 
                        liftIO $ updatePassword a b c 

                    where checkFunction :: String -> String -> String -> Either ParseError (PasswordOp, PasswordOp, Matricule)
                          checkFunction i j k = (,,) <$> verificationPassword i <*> 
                                                         verificationPassword j <*>
                                                         verificationMatricule k