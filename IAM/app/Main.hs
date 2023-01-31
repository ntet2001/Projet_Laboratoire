module Main (main) where

--importation 
import App.VerificationOperateur
import Common.SimpleType
import Infra.SaveOperateur
import Domain.CreationOperateur
import System.IO
import System.Environment
import Text.Parsec
import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Language()

--nom prenom matricule email password photo
main :: IO ()
main = do 
    putStrLn "Enter your Name"
    nom <- getLine
    putStrLn "Enter your Nickname"
    prenom <- getLine
    putStrLn "Enter your matricule"
    matricule <- getLine
    putStrLn "Enter your email"
    email <- getLine
    putStrLn "Enter your password"
    password <- getLine
    putStrLn "Enter your photo"
    photo <- getLine
    let operateur = creerOperateur nom prenom matricule email password photo
    case operateur of
        Right a -> enregistrerOP a
        Left b -> putStrLn "Register Failed"


