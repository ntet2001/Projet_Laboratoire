module Infra.Deconnexion where

import Common.SimpleType
import App.AppPatient
import Domain.CreationOperateur

---------------------------- DeConnection patient----------------------------------------
deconnectPa :: Nom -> IO Patient
deconnectPa nom = do
    let nom1 = verificationNom nom
    case nom1 of
        Right a -> do  
            contenu <- readFile "patient.txt"
            let contenu1 = lines contenu
                contenu2 = map read contenu1 :: [Patient]
                noms = map nameOf contenu2
            if nom `elem` noms 
            then do let listPa = filter (\x -> nameOf x == nom) contenu2
                        pa = head listPa 
                        statut1 = statutP pa
                    if statut1 == Deconnecter 
                    then return pa
                    else return (MkPatient {nameOf = nameOf pa  , firstNameOf = firstNameOf pa, 
                    emailOf = emailOf pa , photoOf = photoOf pa, code = code pa , statutP = Deconnecter}) 
            else fail "Connexion echouer"           
        Left d -> fail  (show d)

---------------------------- DeConnection patient----------------------------------------
deconnectOp :: Matricule -> IO Operateur
deconnectOp mat = do
    let mat1 = verificationMatricule mat
    case mat1 of
        Right a -> do  
            contenu <- readFile "SaveOperateur.txt"
            let contenu1 = lines contenu
                contenu2 = map read contenu1 :: [Operateur]
                matricules = map matricule contenu2
            if mat `elem` matricules 
            then do let listop = filter (\x -> matricule x == mat) contenu2
                        op = head listop 
                        statut1 = statutOp op
                    if statut1 == Deconnecter 
                    then return op
                    else return (MKOperateur { nomOp = nomOp op , prenomOp = prenomOp op ,
                        matricule = matricule op ,email = email op , passwordOp = passwordOp op ,
                        photo = photo op , statutOp = Deconnecter  }) 
            else fail "Connexion echouer"           
        Left d -> fail  (show d)        
