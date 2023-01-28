module Common.SimpleType 
(
Nom, 
NomOp, 
PrenomOp, 
Matricule,
Identifiant,
Email(..),
PasswordOp,
Photo,
Operateur(..),
Visibilite(..),
Statut(..)   
)
where

    {---------------------------=== Importation ===----------------------------------}
    import qualified Data.ByteString.Char8 as C    

    {---------------------------=== Types Definitions ===---------------------------}
    type Nom = String 
    type NomOp = Nom 
    type PrenomOp = Nom 
    type Matricule = String
    type Identifiant = String
    data Statut = Connecter | Deconnecter deriving (Show,Read)
    data Visibilite = Oui | Non deriving (Show,Read,Eq)
    data Email = MkEmail { identifiant :: Identifiant, domaine :: String, extension :: String } deriving (Show ,Read)
    type PasswordOp = String
    type Photo = C.ByteString
    data Operateur = MKOperateur { nomOp :: NomOp, prenomOp :: PrenomOp, matricule::Matricule, email :: Email, passwordOp :: PasswordOp, photo :: Photo, visibilite :: Visibilite, statut :: Statut } deriving (Show,Read) 