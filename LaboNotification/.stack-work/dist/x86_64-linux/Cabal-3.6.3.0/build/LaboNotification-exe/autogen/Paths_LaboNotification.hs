{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_LaboNotification (
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
version = Version [0,0,0,2] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/noumedem/Projet_Laboratoire/LaboNotification/.stack-work/install/x86_64-linux/f18fd7a87cad8790a6a46448caac19aceee692d614b370c45b7b651fd40c5a1e/9.2.5/bin"
libdir     = "/home/noumedem/Projet_Laboratoire/LaboNotification/.stack-work/install/x86_64-linux/f18fd7a87cad8790a6a46448caac19aceee692d614b370c45b7b651fd40c5a1e/9.2.5/lib/x86_64-linux-ghc-9.2.5/LaboNotification-0.0.0.2-7UGWzCGJg3UAnr67IQOQuy-LaboNotification-exe"
dynlibdir  = "/home/noumedem/Projet_Laboratoire/LaboNotification/.stack-work/install/x86_64-linux/f18fd7a87cad8790a6a46448caac19aceee692d614b370c45b7b651fd40c5a1e/9.2.5/lib/x86_64-linux-ghc-9.2.5"
datadir    = "/home/noumedem/Projet_Laboratoire/LaboNotification/.stack-work/install/x86_64-linux/f18fd7a87cad8790a6a46448caac19aceee692d614b370c45b7b651fd40c5a1e/9.2.5/share/x86_64-linux-ghc-9.2.5/LaboNotification-0.0.0.2"
libexecdir = "/home/noumedem/Projet_Laboratoire/LaboNotification/.stack-work/install/x86_64-linux/f18fd7a87cad8790a6a46448caac19aceee692d614b370c45b7b651fd40c5a1e/9.2.5/libexec/x86_64-linux-ghc-9.2.5/LaboNotification-0.0.0.2"
sysconfdir = "/home/noumedem/Projet_Laboratoire/LaboNotification/.stack-work/install/x86_64-linux/f18fd7a87cad8790a6a46448caac19aceee692d614b370c45b7b651fd40c5a1e/9.2.5/etc"

getBinDir     = catchIO (getEnv "LaboNotification_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "LaboNotification_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "LaboNotification_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "LaboNotification_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "LaboNotification_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "LaboNotification_sysconfdir") (\_ -> return sysconfdir)




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
