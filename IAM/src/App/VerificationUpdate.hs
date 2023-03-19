module App.VerificationUpdate where

    import Infra.UpdateOperateur
    import Common.SimpleType
    import Control.Monad.IO.Class

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
                var <- liftIO $ updatePassword oldPassword newPassword matriculepass
                return var