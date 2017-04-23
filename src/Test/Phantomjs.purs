module Test.Phantomjs (
  File()
, PHANTOMJS()
, Timeout()
, Url()
) where

import Control.Monad.Eff (kind Effect)

-- | A computation that executes Phantom.js commands.
-- |
foreign import data PHANTOMJS :: Effect

type File = String
type Url = String
type Timeout = Int
