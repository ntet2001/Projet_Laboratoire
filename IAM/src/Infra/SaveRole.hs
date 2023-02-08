module Infra.SaveRole where 

import Common.SimpleType 


-- fonction pour enregistrer un role  dans le base de donnees des roles 

saveRole :: Role -> String -> IO ()
saveRole role file = do 
    filecontent <- readFile file
    let ligneParligne = lines filecontent 
        toRole = fmap read ligneParligne :: [Role]
        filtredList = filter (role == ) toRole 
    if null filtredList then appendFile file (show role)  
    else do 
        print "le role existe deja"
        return ()