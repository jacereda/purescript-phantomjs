module ObjectTest (
  objectTest
) where

import Prelude
import TestHelpers
import Test.Phantomjs
import Test.Phantomjs.Object as Phantom
import Data.Array
import Data.Maybe

main = phantomSpec do
  objectTest

objectTest = do
  "phantom object" #> do
    "version" #>: do
      version <- liftEff $ Phantom.version
      test "version" $ version.major == 2
    "cookies" #>: do
      cookies <- liftEff $ Phantom.getCookies
      typeTest "cookies" cookies ([Phantom.Cookie { name: "mycookie"
                                                  , value: "mycookievalue"
                                                  , domain: "mydomain.com"
                                                  }])
    "addCookie" #>: do
      worked <- liftEff $ Phantom.addCookie $ Phantom.Cookie { name: "mycookie"
                                                             , value: "mycookievalue"
                                                             , domain: "mydomain.com"
                                                             }
      test "addCookie" $ worked == true

    "deleteCookie" #>: do
      worked <- liftEff $ Phantom.deleteCookie "mycookie"
      test "deleteCookie" $ worked == true

    "clearCookies" #>: do
      liftEff $ Phantom.clearCookies
      cookies <- liftEff $ Phantom.getCookies
      test "clearCookies" $ null cookies

    "getCookiesEnabled" #>: do
      enabled <- liftEff $ Phantom.getCookiesEnabled
      test "getCookiesEnabled" $ enabled == true

    "setCookiesEnabled" #>: do
      liftEff $ Phantom.setCookiesEnabled false
      enabled <- liftEff $ Phantom.getCookiesEnabled
      test "setCookiesEnabled" $ enabled == false

    -- "getLibraryPath" #>: do
    --   libPath <- liftEff $ Phantom.getLibraryPath
    --   pure unit
      -- typeTest "getLibraryPath" libPath ""

    -- "setLibraryPath" #>: do
    --   let path = "/foo/bar/baz"
    --   libPath <- liftEff $ Phantom.setLibraryPath path
    --   libPath <- liftEff $ Phantom.getLibraryPath
    --   test "libraryPath" $ libPath == path
