module Infra.Connexion where

import Common.SimpleType
import App.AppPatient
import Domain.CreationOperateur


       
connectUser ::  Matricule -> PasswordOp ->IO Operateur
connectUser mat passe = do
    let mat1 = verificationMatricule mat
    case mat1 of
        Left d -> fail (show d)
        Right a -> do let passe1 = verificationPassword passe
                      case passe1 of 
                            Right b -> 
                                do  contenu <- readFile "SaveOperateur.txt"
                                    let contenu1 = lines contenu
                                        contenu2 = map read contenu1 :: [Operateur]
                                        --matricules = map matricule contenu2
                                        listop = filter (\x -> matricule x == mat) contenu2
                                        op = head listop 
                                        passeOp = passwordOp op
                                        statut1 = statutOp op
                                    if listop /= [] && passeOp == passe && statut1 == Connecter
                                        then return op
                                        else if listop /= [] && passeOp == passe && statut1 /= Connecter 
                                        then return (MKOperateur { nomOp = nomOp op , prenomOp = prenomOp op ,
                                        matricule = matricule op ,email = email op , passwordOp = passwordOp op ,
                                        photo = photo op , statutOp = Connecter})
                                        else fail "Operateur n'existe pas"
                            Left c -> fail (show c)   
                
connectPa :: Nom -> Int ->IO Patient
connectPa nom code1 = do
    let nom1 = verificationNom nom
    case nom1 of
        Left d -> fail (show d)
        Right a -> do let code2 = verifCode code1
                      case code2 of 
                            Right b -> do  
                                contenu <- readFile "patient.txt"
                                let contenu1 = lines contenu
                                    contenu2 = map read contenu1 :: [Patient]
                                    --matricules = map matricule contenu2
                                    listpa = filter (\x -> nameOf x == nom) contenu2
                                    pa = head listpa 
                                    codePa = code pa
                                    statut1 = statutP pa
                                if listpa /= [] && codePa == code1 && statut1 == Connecter
                                    then return pa
                                    else if listpa /= [] && codePa == code1 && statut1 /= Connecter 
                                    then return (MkPatient {nameOf = nameOf pa  , firstNameOf = firstNameOf pa, 
                                    emailOf = emailOf pa , photoOf = photoOf pa, code = code pa , statutP = Connecter})
                                    else fail "Pateint n'existe pas"
                            Left c -> fail (show c)