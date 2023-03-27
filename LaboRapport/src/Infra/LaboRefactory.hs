{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE FlexibleContexts #-}

module Infra.LaboRefactory where



import Database.MySQL.Simple
import Database.MySQL.Simple.QueryResults
import Database.MySQL.Simple.Result
import Data.Aeson.TH
import Data.Aeson
import Common.SimpleTypes
import Data.Time
import Infra.ReadRapport
import Data.List


-- il faut creer une nouvelle table da la bd labo_rapport où seront enregistrees toutes les fiches venant de EFA
-- cette table s'appellera fiche

-- fonction qui prend l'id d'une fiche et ressort le rappport correspondant 

-- je pouvais passee directement la fiche dans la requette mais pour cela il faudrait ecrire une (instance Param Fiche) 
    -- moyen de contourner le pb : faire un filtrage dans tous les rapports

getRapport :: Int -> IO Rapport
getRapport unIdDeFiche = do
    -- je ressort tous les rapport du systeme
    allRapport <- readRapport
    -- cherche le rapport dans lequel l'id de sa fiche est celle passee en parametre
    let filterList = concatMap (\x -> ([x | idFiche (fiche x) == unIdDeFiche])) allRapport
    -- si la liste est nulle alors le rapport n'hesite pas 
    if null filterList then fail $ "le rapport de la fiche dont l'id est " ++  show unIdDeFiche ++ " n'existe pas encore "
    else return $ head filterList
