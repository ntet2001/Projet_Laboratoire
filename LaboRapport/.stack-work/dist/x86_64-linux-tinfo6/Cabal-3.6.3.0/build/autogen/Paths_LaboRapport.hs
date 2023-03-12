{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_LaboRapport (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/ntetigor/Documents/labo/Projet_Laboratoire/LaboRapport/.stack-work/install/x86_64-linux-tinfo6/5098950669dfbc7e30821bd5a8e4c46e8d8a492289313d981b78872084f9ded7/9.2.7/bin"
libdir     = "/home/ntetigor/Documents/labo/Projet_Laboratoire/LaboRapport/.stack-work/install/x86_64-linux-tinfo6/5098950669dfbc7e30821bd5a8e4c46e8d8a492289313d981b78872084f9ded7/9.2.7/lib/x86_64-linux-ghc-9.2.7/LaboRapport-0.1.0.0-IVo80URAAClEXv6YWEPgGk"
dynlibdir  = "/home/ntetigor/Documents/labo/Projet_Laboratoire/LaboRapport/.stack-work/install/x86_64-linux-tinfo6/5098950669dfbc7e30821bd5a8e4c46e8d8a492289313d981b78872084f9ded7/9.2.7/lib/x86_64-linux-ghc-9.2.7"
datadir    = "/home/ntetigor/Documents/labo/Projet_Laboratoire/LaboRapport/.stack-work/install/x86_64-linux-tinfo6/5098950669dfbc7e30821bd5a8e4c46e8d8a492289313d981b78872084f9ded7/9.2.7/share/x86_64-linux-ghc-9.2.7/LaboRapport-0.1.0.0"
libexecdir = "/home/ntetigor/Documents/labo/Projet_Laboratoire/LaboRapport/.stack-work/install/x86_64-linux-tinfo6/5098950669dfbc7e30821bd5a8e4c46e8d8a492289313d981b78872084f9ded7/9.2.7/libexec/x86_64-linux-ghc-9.2.7/LaboRapport-0.1.0.0"
sysconfdir = "/home/ntetigor/Documents/labo/Projet_Laboratoire/LaboRapport/.stack-work/install/x86_64-linux-tinfo6/5098950669dfbc7e30821bd5a8e4c46e8d8a492289313d981b78872084f9ded7/9.2.7/etc"

getBinDir     = catchIO (getEnv "LaboRapport_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "LaboRapport_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "LaboRapport_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "LaboRapport_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "LaboRapport_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "LaboRapport_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
