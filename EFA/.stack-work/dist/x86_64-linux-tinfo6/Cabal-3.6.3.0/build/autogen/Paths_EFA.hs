{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_EFA (
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
bindir     = "/home/ntetigor/Documents/labo/Projet_Laboratoire/EFA/.stack-work/install/x86_64-linux-tinfo6/f5db4eb93d5c118a466cb9aea8da292801864e9471f4254531441f021d525a7a/9.2.5/bin"
libdir     = "/home/ntetigor/Documents/labo/Projet_Laboratoire/EFA/.stack-work/install/x86_64-linux-tinfo6/f5db4eb93d5c118a466cb9aea8da292801864e9471f4254531441f021d525a7a/9.2.5/lib/x86_64-linux-ghc-9.2.5/EFA-0.1.0.0-Hb0MS2DfEfEHyiPNJQBthY"
dynlibdir  = "/home/ntetigor/Documents/labo/Projet_Laboratoire/EFA/.stack-work/install/x86_64-linux-tinfo6/f5db4eb93d5c118a466cb9aea8da292801864e9471f4254531441f021d525a7a/9.2.5/lib/x86_64-linux-ghc-9.2.5"
datadir    = "/home/ntetigor/Documents/labo/Projet_Laboratoire/EFA/.stack-work/install/x86_64-linux-tinfo6/f5db4eb93d5c118a466cb9aea8da292801864e9471f4254531441f021d525a7a/9.2.5/share/x86_64-linux-ghc-9.2.5/EFA-0.1.0.0"
libexecdir = "/home/ntetigor/Documents/labo/Projet_Laboratoire/EFA/.stack-work/install/x86_64-linux-tinfo6/f5db4eb93d5c118a466cb9aea8da292801864e9471f4254531441f021d525a7a/9.2.5/libexec/x86_64-linux-ghc-9.2.5/EFA-0.1.0.0"
sysconfdir = "/home/ntetigor/Documents/labo/Projet_Laboratoire/EFA/.stack-work/install/x86_64-linux-tinfo6/f5db4eb93d5c118a466cb9aea8da292801864e9471f4254531441f021d525a7a/9.2.5/etc"

getBinDir     = catchIO (getEnv "EFA_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "EFA_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "EFA_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "EFA_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "EFA_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "EFA_sysconfdir") (\_ -> return sysconfdir)




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
