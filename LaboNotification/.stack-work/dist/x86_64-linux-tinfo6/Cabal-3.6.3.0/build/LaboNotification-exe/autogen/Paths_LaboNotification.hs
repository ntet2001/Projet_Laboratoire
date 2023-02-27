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
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/nkalla/Documents/HaskellWorkSpace/LaboNotification/.stack-work/install/x86_64-linux-tinfo6/1b41269549c09bdb0047202ba4b222c17db472c7de3bfffe8a3e90b6ce171cd4/9.2.5/bin"
libdir     = "/home/nkalla/Documents/HaskellWorkSpace/LaboNotification/.stack-work/install/x86_64-linux-tinfo6/1b41269549c09bdb0047202ba4b222c17db472c7de3bfffe8a3e90b6ce171cd4/9.2.5/lib/x86_64-linux-ghc-9.2.5/LaboNotification-0.1.0.0-B3ZlMFvNZ6z5zy14iHNoII-LaboNotification-exe"
dynlibdir  = "/home/nkalla/Documents/HaskellWorkSpace/LaboNotification/.stack-work/install/x86_64-linux-tinfo6/1b41269549c09bdb0047202ba4b222c17db472c7de3bfffe8a3e90b6ce171cd4/9.2.5/lib/x86_64-linux-ghc-9.2.5"
datadir    = "/home/nkalla/Documents/HaskellWorkSpace/LaboNotification/.stack-work/install/x86_64-linux-tinfo6/1b41269549c09bdb0047202ba4b222c17db472c7de3bfffe8a3e90b6ce171cd4/9.2.5/share/x86_64-linux-ghc-9.2.5/LaboNotification-0.1.0.0"
libexecdir = "/home/nkalla/Documents/HaskellWorkSpace/LaboNotification/.stack-work/install/x86_64-linux-tinfo6/1b41269549c09bdb0047202ba4b222c17db472c7de3bfffe8a3e90b6ce171cd4/9.2.5/libexec/x86_64-linux-ghc-9.2.5/LaboNotification-0.1.0.0"
sysconfdir = "/home/nkalla/Documents/HaskellWorkSpace/LaboNotification/.stack-work/install/x86_64-linux-tinfo6/1b41269549c09bdb0047202ba4b222c17db472c7de3bfffe8a3e90b6ce171cd4/9.2.5/etc"

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
