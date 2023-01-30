module Common.SimpleType where

    {---------------------------=== Importation ===----------------------------------}
    import qualified Data.ByteString.Char8 as C    

    {---------------------------=== Types Definitions ===---------------------------}
    type Nom = String 
    type NomOp = Nom 
    type PrenomOp = Nom 
    type NomPatient = Nom
    type PrenomPatient = Nom
    type Matricule = String
    type Identifiant = String
    data Statut = Connecter | Deconnecter | Supprimer | Bloquer | Aucun deriving (Show,Read,Eq) 
    data Email = MkEmail { identifiant :: Identifiant, domaine :: String, extension :: String } deriving (Show ,Read, Eq)
    type PasswordOp = String
    type Photo = C.ByteString
    data Operateur = MKOperateur { nomOp :: NomOp, prenomOp :: PrenomOp, matricule::Matricule, 
        email :: Email, passwordOp :: PasswordOp, photo :: Photo, statut :: Statut } deriving (Show,Read) 
    
    data Patient = MkPatient {nameOf :: Nom , postNameOf :: Nom , 
                emailOf :: Email, photoOf :: Photo, code :: Int, statut :: Statut } deriving (Show , Read , Eq)
    
    data User = Operateur | Patient deriving (Show, Read, Eq)

    data Role = MkRole {nameRole :: NomRole, roleUserList :: Access } deriving (Show, Read, Eq)
    type ListMatricule = [Matricule] 
    type ListAccessCode = [Int] 
    data Access = ListMatricule | ListAccessCode deriving (Show, Read, Eq)
    data NomRole = Admin | Laborantain | Secretaire | SimplePatient  deriving (Show, Read, Eq)