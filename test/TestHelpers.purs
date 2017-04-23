module TestHelpers (
  (#>)
, (#>:)
, phantomSpec
, pendingWith
, test
, typeTest
, module Control.Monad.Eff.Class
) where

import Prelude
import Test.Spec
import Test.Spec.Runner
import Test.Spec.Reporter.Console
import Test.Spec.Assertions
import Control.Monad.Aff
import Control.Monad.Aff.Console
import Control.Monad.Eff
import Control.Monad.Eff.Class
import Control.Monad.Eff.Timer (TIMER)
import Control.Monad.Aff.AVar (AVAR)
import Test.Phantomjs(PHANTOMJS)
import Test.Phantomjs.Object as Phantom

infixr 0 describe as #> 
infixr 0 it as #>:

pendingWith :: forall r. String -> Spec r Unit
pendingWith = pending

phantomSpec :: Spec (RunnerEffects (phantomjs :: PHANTOMJS)) Unit -> Eff (RunnerEffects (phantomjs :: PHANTOMJS)) Unit
phantomSpec tests = run [consoleReporter] tests *> Phantom.exit 0

-- This is a (possibly) temporary hack. We're running a feature test
-- with Phantom - except that Phantom is running *us* after we get
-- compiled. Because of this, we need to print our own output.
test :: forall e. String -> Boolean -> Aff (console :: CONSOLE | e) Unit
test desc cond = do
  log $ (if cond then "Success" else "FAILURE") <> ": " <> desc
  unit `shouldEqual` unit

asTypeOf :: forall a. a -> a -> a
asTypeOf x _ = x

typeTest :: forall e a. String -> a -> a -> Aff (console :: CONSOLE | e) Unit
typeTest desc value matchType = do
  void $ pure $ value `asTypeOf` matchType
  log $ "Successfully typed: " <> desc
  unit `shouldEqual` unit
