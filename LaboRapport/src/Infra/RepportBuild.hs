module Infra.RepportBuild where

import System.IO

-- function to build a repport who take in entries a repport
repportBuilding :: String -> String -> IO FilePath
repportBuilding repport idRepport =  do
    writeFile idRepport repport
    return $ "/home/ntetigor/Documents/" ++  idRepport