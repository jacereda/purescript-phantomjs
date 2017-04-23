module WebpageTest (
  webpageTest
) where

import Prelude
import TestHelpers
import Test.Phantomjs
import Test.Phantomjs.Webpage as W
import Test.Phantomjs.Webpage.PaperSizeUtil as WP
--import Control.Monad.Aff.Console
import Control.Monad.Eff.Class
import Math (abs)

main = phantomSpec do
  webpageTest

webpageTest = do
  "webpage module" #>: do
    page <- liftEff W.create
    W.open page "http://example.com"
    test "create" $ true
    test "open" $ true

    url <- liftEff $ W.url page
    test "url" $ url == "http://example.com/"

    -- content <- liftEff $ W.content page
    -- test "content" $ content == exampleHtml

    -- text <- liftEff $ W.plainText page
    -- test "plainText" $ text == exampleText

    W.ScrollPosition scrollPos <- liftEff $ W.getScrollPosition page
    test "getScrollPosition" $ scrollPos.top == 0 && scrollPos.left == 0

    liftEff $ W.setScrollPosition page (W.ScrollPosition {top: 10, left: 10})
    W.ScrollPosition scrollPos <- liftEff $ W.getScrollPosition page
    test "setScrollPosition" $ scrollPos.top == 10 && scrollPos.left == 10

    liftEff $ W.setViewportSize page (W.ViewportSize {width: 10, height: 10})
    W.ViewportSize size <- liftEff $ W.getViewportSize page
    test "get and set viewportSize" $ size.width == 10 && size.height == 10

    liftEff $ W.setZoomFactor page 0.10
    size <- liftEff $ W.getZoomFactor page
    test "get and set zoomFactor" $ abs (size - 0.10) < 0.000001

    liftEff $ WP.setPaperSize page $ WP.PaperSize (WP.PaperDimensions WP.A4 WP.Portrait) WP.noMargin
    test "set paperSize" $ true


exampleText = """Example Domain

This domain is established to be used for illustrative examples in documents. You may use this domain in examples without prior coordination or asking for permission.

More information...
"""

exampleHtml = """<!DOCTYPE html><html><head>
    <title>Example Domain</title>

    <meta charset="utf-8">
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style type="text/css">
    body {
        background-color: #f0f0f2;
        margin: 0;
        padding: 0;
        font-family: "Open Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;

    }
    div {
        width: 600px;
        margin: 5em auto;
        padding: 50px;
        background-color: #fff;
        border-radius: 1em;
    }
    a:link, a:visited {
        color: #38488f;
        text-decoration: none;
    }
    @media (max-width: 700px) {
        body {
            background-color: #fff;
        }
        div {
            width: auto;
            margin: 0 auto;
            border-radius: 0;
            padding: 1em;
        }
    }
    </style>
</head>

<body>
<div>
    <h1>Example Domain</h1>
    <p>This domain is established to be used for illustrative examples in documents. You may use this
    domain in examples without prior coordination or asking for permission.</p>
    <p><a href="http://www.iana.org/domains/example">More information...</a></p>
</div>


</body></html>"""
