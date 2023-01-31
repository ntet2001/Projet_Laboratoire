module App.VerificationOperateur where

    --importation of Type
    import qualified Data.ByteString.Char8 as C
    import Text.Parsec
    import Text.ParserCombinators.Parsec
    import Text.ParserCombinators.Parsec.Language()
    import qualified Common.SimpleType as ST
    import Data.List

    {--------------------------------==== Function to validate the name ====--------------------------------}
    parserNom :: Parser ST.Nom
    parserNom = do
        nom <- getInput
        if (length nom) < 2 then 
            unexpected "Photo invalide"
        else 
            return nom

    verificationNom :: String -> Either ParseError ST.Nom
    verificationNom nom = parse parserNom "" nom

    {--------------------------------==== Function to validate the email ====--------------------------------}
    fonctpoint :: String -> String
    fonctpoint xs
        | nbrePoints >= 1 = if last xs == '.' then "" 
                else f xs 
        | otherwise = xs
                where   nbrePoints = length $ elemIndices '.' xs
                        f :: String -> String 
                        f xs = let (i:is) = elemIndices '.' xs 
                                   (l:m:ys) = [x | x <- [xs !! j | j <- [i..(length xs)]]]
                                in if ([l,m] == "..") then "" 
                                else xs

    parserEmail :: Parser ST.Email -- jean94@domain.com
    parserEmail = do 
        n1 <- many (noneOf "@")
        let identifiant = fonctpoint n1
        char '@'
        domaine <- many (letter <|> digit)
        char '.'
        extension <- many (letter <|> digit <|> noneOf "@" )
        return $ ST.MkEmail identifiant domaine extension

    verificationEmail :: String -> Either ParseError ST.Email
    verificationEmail email = parse parserEmail "email non valide" email

    {----------==== Function to validated the picture ====-----------------}
    parserPhoto :: Parser ST.Photo
    parserPhoto = do
        photo <- getInput
        let a = C.pack photo
            b = C.length a
        if b < 5 then 
            unexpected "Photo invalide"
        else 
            return a

    verificationPhoto :: String -> Either ParseError ST.Photo
    verificationPhoto = parse parserPhoto "Nom valide"
        