
module App.Resultat where

import Common.SimpleTypes
import Infra.ReadRapport
import Infra.ReadResult
import Infra.UpdateRapport
import Domain.CreateResultat
import qualified Infra.SaveResult as I


saveResult :: Int -> String-> String -> Int -> String -> Int -> [String] -> String -> IO String
saveResult idOfAnalyse interpret conclusion oneIdFiche prescriptor numberDossier lineOfResult someName = do
    -- je ressort d'abord le rapport dont l'id est numberDossier
    currentRapport <- readARapport numberDossier
    -- je verifie si oneIdFiche correspond a l'id de la fiche presente dans le rapport
    let ficheDuRapport = fiche currentRapport
    if idFiche ficheDuRapport == oneIdFiche then do
        -- je verifie si l'id de l'analyse est dans la liste des id d'analyse de la fiche
        let listIdOfAnalyse = analyses ficheDuRapport
        if show idOfAnalyse `elem` listIdOfAnalyse then do 
            -- je verifie si l'id de l'analyse n'est pas deja present dans la liste des resultats de la fiche
            listeDesReslutats <- readResultFiche oneIdFiche
            let someList = [resultat | resultat <- listeDesReslutats, idAnal resultat == idOfAnalyse ] 
            case someList of
                [] -> do 
                    -- j'effectue les differentes verifications avant de construire le resultat
                    -- toutes les chaines de caracteres ne doivent pas etre vides
                    if null interpret || null conclusion || null prescriptor || null lineOfResult || null someName then 
                        fail "l'interpretation, la conclusion, le prescripteur ou le nom du laborantain ne doit pas etre "
                    -- je verifie que tous les entiers sont positifs 
                    else do 
                        let checkInputInt = alwaysPositifs idOfAnalyse oneIdFiche numberDossier 
                        case checkInputInt of
                            Left _ -> fail "l'id de l'analyse, l'id de la fiche et le numero du dossier doivent etre positifs"
                            Right (x,y,z) -> do
                                -- je verifie si les string sont corrects
                                let checkInputString = correctString interpret conclusion prescriptor someName 
                                case checkInputString of
                                    Left _ -> fail "l'interpretation, la conclusion, le prescripteur, et le nom du laborantain doivent etre constitues des lettres de l'alphabet francais"
                                    Right (a,b,c,d) -> do
                                        -- je verifie les elements de type lineOfResult
                                        let checkLine = fmap checkLineResult lineOfResult
                                        case sequenceA checkLine of
                                            Left msg -> fail msg
                                            Right something -> do 
                                                -- ici il faut generer un id pour le resultat
                                                leResultat <- createResultat 1 x a b y c z something d
                                                -- j'enregistre d'abord et puis je vais recuperer l'id qui est dans la bd
                                                isGood <- I.saveResult leResultat
                                                case isGood of
                                                    "Successful" -> do
                                                        let updateContenu = 1 : (contenu currentRapport)
                                                        updateRapport numberDossier updateContenu              
                                                    "Failed" -> fail "le resultat n'a pas pu etre enregistré"
                (x:_) -> do
                    -- mis a jour du contenu : j'ajoute l'id du resultat au contenu du rapport et puis l'envoie a updateRapport
                    let newcontenu =  (idResult x) : (contenu currentRapport)
                    updateRapport numberDossier newcontenu
        else fail $ "l'analyse dont l'id est : " ++ show idOfAnalyse ++ " n'est pas sur la fiche dont l'id est : " ++ show oneIdFiche

    else fail $ "la fiche dont l'id est : " ++ show oneIdFiche ++ 
        " ne correspond pas celle presente dans le rapport dont l'id est : " ++ show numberDossier

























