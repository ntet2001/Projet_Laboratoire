module App.VerificationRapport where

    import Domain.CreateRapport
    import Common.SimpleTypes
    import Infra.SaveRapport

    createNewRepport :: Fiche -> IO String
    createNewRepport fiche = do 
        rapport <- createRapport fiche (idFiche fiche)
        saveRapport rapport