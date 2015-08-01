module Test.Phantomjs.Webpage (
  BrowserProc()
, Page()
, create
, evaluate0
, open
, openWithTimeout
, render
) where

import Prelude

import Control.Alt
import Control.Monad.Eff.Exception
import Control.Monad.Eff
import Control.Monad.Aff
import Control.Monad.Aff.AVar
import Control.Monad.Aff.Par
import Control.Monad.Error.Class
import Test.Phantomjs

-- | Represents a NON-closure procedure that will be run in the
-- | browser environment.
-- |
foreign import data BrowserProc :: * -> *

-- | An instance of Phantom's `webpage`.
-- |
foreign import data Page :: *

-- | Creates an instance of Phantom's `webpage`.
-- |
foreign import create
  :: forall e. Eff (phantomjs :: PHANTOMJS | e) Page

-- | Run a NON-closure procedure in the browser
-- | environment. `evaluateN` takes N arguments. Arguments must be
-- | JSON-serializable.
-- |
foreign import evaluate0
  :: forall e a.
     Page
  -> BrowserProc a
  -> Eff (phantomjs :: PHANTOMJS | e) a

-- | Run a NON-closure procedure in the browser
-- | environment. `evaluateN` takes N arguments. Arguments must be
-- | JSON-serializable.
-- |
foreign import evaluate1
  :: forall e a b.
     Page
  -> (a -> BrowserProc b)
  -> a
  -> Eff (phantomjs :: PHANTOMJS | e) b

-- | Run a NON-closure procedure in the browser
-- | environment. `evaluateN` takes N arguments. Arguments must be
-- | JSON-serializable.
-- |
foreign import evaluate2
  :: forall e a b c.
     Page
  -> (a -> b -> BrowserProc c)
  -> a
  -> b
  -> Eff (phantomjs :: PHANTOMJS | e) c

-- | Run a NON-closure procedure in the browser
-- | environment. `evaluateN` takes N arguments. Arguments must be
-- | JSON-serializable.
-- |
foreign import evaluate3
  :: forall e a b c d.
     Page
  -> (a -> b -> c -> BrowserProc d)
  -> a
  -> b
  -> c
  -> Eff (phantomjs :: PHANTOMJS | e) d

-- | Opens a connection to the given URL.
-- |
open :: forall e. Page -> String -> Aff (phantomjs :: PHANTOMJS | e) Unit
open page url = makeAff (\onError onSuccess -> _open
                                               onError
                                               (onSuccess unit)
                                               page
                                               url)


-- | Opens a connection to the given URL, but may fail with a timeout.
-- |
openWithTimeout ::
  forall e. Page -> String -> Timeout -> Aff ( avar :: AVAR
                                             , phantomjs :: PHANTOMJS | e) Unit
openWithTimeout page url timeout =
  runPar $
  (Par $ pure unit) <|>
  (Par $ later' timeout (throwError $ timeoutError timeout))
  where
    timeoutError timeout = error $ "Timed out after " ++ show timeout ++ " seconds"

-- | Renders the page image to a file. File extension determines
-- | format. Accepts: PNG, GIF, JPEG, PDF.
-- |
foreign import render
  :: forall e.
     Page
  -> File
  -> Eff (phantomjs :: PHANTOMJS | e) Unit

foreign import _open
  :: forall e.
     (Error -> Eff (phantomjs :: PHANTOMJS | e) Unit)
  -> Eff (phantomjs :: PHANTOMJS | e) Unit
  -> Page
  -> String
  -> Eff (phantomjs :: PHANTOMJS | e) Unit
