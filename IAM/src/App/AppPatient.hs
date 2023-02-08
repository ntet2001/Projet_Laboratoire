{-# OPTIONS_GHC -Wno-missing-export-lists #-}
module App.AppPatient where 

import System.Random
import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Language()
import Data.List

-- fonction pour generer un code patient qui doit avoir au moins 4 chiffres 

genCode :: IO Int
genCode = do
    generator <- newStdGen 
    let (x,_) = randomR (0000,9999) generator
    return x
 
verifCode :: Int -> Either ParseError Int  
verifCode codeAcces = do
    let x = show codeAcces
    result <- parse parserCode "" x
    return result 

parserCode :: Parser Int 
parserCode = do 
    x <- many1 digit 
    case (length x) == 4 of 
        True -> return (read x :: Int) 
        False -> unexpected "code invalide " 