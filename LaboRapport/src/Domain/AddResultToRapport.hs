module Domain.AddResultToRapport where


import Common.SimpleTypes
import Infra.UpdateRapport
import Infra.ReadRapport

-- la fonction updateRapport met a jour le contenu du rapport dans la base de donnees

-- addResult :: Rapport -> IdResult -> IO () 
-- addResult someRapport someId = updateRapport (idRapport someRapport) [someId]

-- cette fonction doit modifier le contenu du rapport initial

type IdRapport = Int

addResult :: IdRapport -> Resultat -> IO String
addResult someId  resultat = do
    -- cherche le rapport correspondant a l'id en parametre 
    matchedRapport <- readARapport someId
    -- verifie si la fiche contenu dans le resultat est la meme que celle dans le rapport
    let ficheSurRapport = fiche matchedRapport 
        id2 = fiche' resultat 
    if idFiche ficheSurRapport == id2 then 
        do 
            let listOfAnalyse = analyses ficheSurRapport
                analDuResultat = idAnal resultat
            if show analDuResultat `elem` listOfAnalyse then 
            -- appelle de la fonction updateRapport avec les id des resultats passés en parametre
                updateRapport someId [idResult resultat]
            else fail "l'analyse dont le resultat est passé en parametre ne correspond à aucune analyse"
    else fail "cette fiche ne correspond pas a ce rapport"
 