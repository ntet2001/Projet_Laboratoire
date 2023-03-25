module App.VerificationRapport where

    import Domain.CreateRapport
    import Common.SimpleTypes
    import Infra.SaveRapport

    {-===== function that created a repport by the simple call of 
        * createRapport in the domain
        * saveRapport in the infrastructure
    =======-}
    createNewRepport :: Fiche -> IO String
    createNewRepport fiche = do 
        rapport <- createRapport fiche (idFiche fiche)
        saveRapport rapport

    {-====== function that take in input the name of the patient an return the 
    list of his repport
     ======-}
    searchRapportName :: String -> IO Rapport 
    searchRapportName name = undefined