module Test.BrowserProcs where

import Prelude
import Test.Phantomjs.Webpage (BrowserProc)

foreign import docTitle
  :: BrowserProc String

foreign import getIntX
  :: BrowserProc Int

foreign import setIntX
  :: Int
  -> BrowserProc Unit
