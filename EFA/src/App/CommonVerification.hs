{-# LANGUAGE OverloadedStrings #-}
module App.CommonVerification where

import Common.SimpleTypes
import qualified Data.ByteString.Char8 as C8
import GHC.Generics
import Database.MySQL.Simple


verifNom :: String -> Either String String
verifNom nom = if (length nom < 2)
    then (Left "Nom ou Prenom invalide")
    else (Right nom)

verifVal :: ValUsuel -> Either String ValUsuel
verifVal val = case val of
    Vide -> Right Vide
    UneValFloat a -> Right (UneValFloat a)
    UneValString d -> Right (UneValString d)
    Interval b c  -> Right (Interval b c)
    _ -> Left "Valeur usuel incorrect"

verifCat :: Categorie -> Either String Categorie
verifCat cat = case cat of
    Biochimie -> Right Biochimie
    Hematologie -> Right Hematologie
    Serologie -> Right Serologie
    Parasitologie -> Right Parasitologie
    _ -> Left "Categorie incorrect"



