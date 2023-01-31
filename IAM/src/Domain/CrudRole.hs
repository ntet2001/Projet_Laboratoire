{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
module Domain.CrudRole where 

import Common.SimpleType

-- fonction qui assigne un role a un utilisateur 

addRole :: NomRole -> Role -> User Operateur Patient -> Maybe Role
addRole someName someRole (Operateur op) = opRole someName someRole (matricule op) 
addRole someName someRole (Patient pa ) = paRole someName someRole (code pa) 

-- fonction qui donne un role a un utilisateur type Operateur 

opRole :: NomRole -> Role -> Matricule -> Maybe Role
opRole n r m = do 
    if nameRole r == n then do 
        let var = roleUserList r 
        case var of 
            ListMatricule listeMatri -> do
                let val = m : listeMatri   
                return MkRole {nameRole = n , roleUserList = ListMatricule val }
            ListAccessCode _ -> Nothing 
    else Nothing 

--fonction qui donne un role a un utilisateur type Patient 

paRole :: NomRole -> Role -> Int -> Maybe Role
paRole name role input = do
    if name == nameRole role then do
        let sortie = roleUserList role  
        case sortie of 
            ListAccessCode listeCode -> do
                let updateListeCode = input : listeCode 
                return MkRole {nameRole = name , roleUserList = ListAccessCode updateListeCode }
            ListMatricule _ -> Nothing 
    else Nothing 

-- fonction pour demettre un role d'un utilisateur 

deleteRole :: NomRole -> User Operateur Patient -> Role -> Either String Role
deleteRole nom (Operateur x) someRole = do
    if nom == nameRole someRole then do
        let something = roleUserList someRole   -- recupere la liste des id des utilisateurs qui ont ce role 
        case something of  
            ListMatricule listOfId -> do
                let userMatricule = matricule x  -- recupere le matricule de l'operateur x 
                if userMatricule `elem` listOfId then 
                    return MkRole {nameRole = nom , roleUserList = ListMatricule [y | y <- listOfId , userMatricule `notElem` listOfId]}
                else Left "le matricule de cette operateur n'est pas dans la liste des roles "
            ListAccessCode _ -> Left "un utilisateur type Operateur ne peut pas jouer le role d'un simple patient"
    else Left "le nom du role ne correspond pas "
deleteRole nom (Patient p) someRole = do
    if nom == nameRole someRole then do
        let someStuff = roleUserList someRole   -- recupere la liste des codes des utilisateurs qui ont ce role 
        case  someStuff of 
            ListAccessCode listOfCode -> do
                let val = code p                -- recupere le code du patient p 
                if val `elem` listOfCode then 
                    return MkRole {nameRole = nom , roleUserList = ListAccessCode [w | w <- listOfCode , val `notElem` listOfCode]}
                else Left "le code de ce patient n'est pas dans la liste des roles"
            ListMatricule _ -> Left "un utilisateur patient ne peut pas jouer le role d'un operateur"
    else Left "le nom du role ne correspond pas"


-- fonction qui ressort la liste de tous les role joués par un utilisateur 

searchUser :: User Operateur Patient -> String -> IO [Maybe NomRole] -- IO [Maybe NomRole] est plus facile a gerer
searchUser (Operateur x) file = do
    fileContent <- readFile file
    let lignes = lines fileContent
        toRole = fmap read lignes :: [Role]
        lookingForRole = fmap (f (matricule x)) toRole
    return lookingForRole
    where f :: Matricule -> Role -> Maybe NomRole
          f m rl = do
            let listofId = roleUserList rl 
            case listofId of 
                ListMatricule mtr -> do
                    if m `elem` mtr then return $ nameRole rl
                    else Nothing 
                ListAccessCode _  -> Nothing 
searchUser (Patient y) file = do 
    fileContent <- readFile file
    let lignes = lines fileContent
        toRole = fmap read lignes :: [Role]
        lookingforRole = fmap (g (code y)) toRole
    return lookingforRole
    where g :: Int -> Role -> Maybe NomRole 
          g code role = do
            let var = roleUserList role  
            case var of 
                ListAccessCode somecode -> do
                    if code `elem` somecode then return $ nameRole role
                    else Nothing 
                ListMatricule _ -> Nothing 
