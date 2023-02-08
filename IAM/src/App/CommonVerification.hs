module App.CommonVerification where

    {--------------------------===== Importations ======-------------------------------------}
    import Text.ParserCombinators.Parsec
    import Text.ParserCombinators.Parsec.Language()
    import qualified Data.Text as C
    import Common.SimpleType
    import Data.List

    {--------------------------------==== Function to validate the email ====--------------------------------}
    fonctpoint :: String -> String
    fonctpoint xs
        | nbrePoints >= 1 = if last xs == '.' then "" 
                else f xs 
        | otherwise = xs
                where   nbrePoints = length $ elemIndices '.' xs
                        f :: String -> String 
                        f xs =  let (i:is) = elemIndices '.' xs 
                                    (l:m:ys) = [x | x <- [xs !! j | j <- [i..(length xs)]]]
                                in if ([l,m] == "..") then "" 
                                else xs

    {--------------------------------==== Function to validate the name ====--------------------------------}
    parserNom :: Parser Nom
    parserNom = do
        nom <- getInput
        if (length nom) < 2 then 
            unexpected "nom invalide"
        else 
            return nom

    verificationNom :: String -> Either ParseError Nom
    verificationNom nom = parse parserNom "" nom

    {----------==== Function to validated the email ====-----------------}

    parserEmail :: Parser Email -- jean94@domain.com
    parserEmail = do 
        n1 <- many (noneOf "@")
        let identifiant = fonctpoint n1
        char '@'
        domaine <- many (letter <|> digit)
        char '.'
        extension <- many (letter <|> digit <|> noneOf "@" )
        return $ MkEmail identifiant domaine extension

    verificationEmail :: String -> Either ParseError Email
    verificationEmail email = parse parserEmail "email non valide" email

    {----------==== Function to validated the picture ====-----------------}
    parserPhoto :: Parser Photo
    parserPhoto = do
        photo <- getInput
        let a = C.pack photo
            b = C.length a
        if b < 5 then 
            unexpected "Photo invalide"
        else 
            return a

    verificationPhoto :: String -> Either ParseError Photo
    verificationPhoto = parse parserPhoto "Nom valide"

    {--------------------------==== Function to validated Statut ====----------------------------------}
    verificationStatut :: String -> Either ParseError Statut 
    verificationStatut = parse parserStatut "" 
        where parserStatut = do
                            statut <- many letter
                            case statut of
                                "Aucun" -> return Aucun
                                "Connecter" -> return Connecter