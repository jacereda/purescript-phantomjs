module Test.Phantomjs.Webpage.PaperSizeUtil (
  Format(..)
, Length(..)
, Margin(..)
, Orientation(..)
, PaperDimensions(..)
, PaperSize(..)
, Top()
, Left()
, Right()
, Bottom()
, Height()
, Width()
, PageNum()
, NumPages()
, noMargin
-- , getPaperSize
, setPaperSize
) where

import Prelude
import Data.Function
import Data.Maybe
import Control.Monad.Eff
import Test.Phantomjs
import Data.Int
import Test.Phantomjs.Webpage

type Top = Length
type Left = Length
type Right = Length
type Bottom = Length
type Height = Length
type Width = Length
type PageNum = Int
type NumPages = Int


-- data Footer = Footer Height (PhantomCallback2 PageNum NumPages String)
data Format = A3 | A4 | A5 | Legal | Letter | Tabloid
-- data Header = Header Height (PhantomCallback2 PageNum NumPages String)
data Length = Pixels Int
            | Inches Number
            | Centimeters Number
            | Millimeters Number
data Margin = Margin Top Left Bottom Right
data Orientation = Landscape | Portrait
data PaperDimensions = PaperDimensions Format Orientation
                     | PaperDimensionsLxW Length Length


data PaperSize = PaperSize PaperDimensions Margin -- (Maybe Header) (Maybe Footer)

noMargin = Margin (Pixels 0) (Pixels 0) (Pixels 0) (Pixels 0)

setPaperSize
  :: forall e.
     Page
  -> PaperSize
  -> Eff (phantomjs :: PHANTOMJS | e) Unit
setPaperSize page (PaperSize (PaperDimensions format orientation) (Margin t l b r))
  = _setPaperSize page { format: show format
                       , orientation: show orientation
                       , margin: { top: lengthToNumber t
                                 , left: lengthToNumber l
                                 , bottom: lengthToNumber b
                                 , right: lengthToNumber r
                                 }
                       }
setPaperSize page (PaperSize (PaperDimensionsLxW h w) (Margin t l b r))
 = _setPaperSizeLW page { width: lengthToNumber w
                        , height: lengthToNumber h
                        , margin: { top: lengthToNumber t
                                  , left: lengthToNumber l
                                  , bottom: lengthToNumber b
                                  , right: lengthToNumber r
                                  }
                        }

foreign import _setPaperSize
  :: forall e.
     Page
  -> { format :: String
     , orientation :: String
     , margin :: { top :: Number
               , left :: Number
               , bottom :: Number
               , right :: Number
               }
     }
  -> Eff (phantomjs :: PHANTOMJS | e) Unit

foreign import _setPaperSizeLW
  :: forall e.
     Page
  -> { width :: Number
     , height :: Number
     , margin :: { top :: Number
                 , left :: Number
                 , bottom :: Number
                 , right :: Number
                 }
     }
  -> Eff (phantomjs :: PHANTOMJS | e) Unit


instance showFormat :: Show Format where
  show A3 = "A3"
  show A4 = "A4"
  show A5 = "A5"
  show Legal = "Legal"
  show Letter = "Letter"
  show Tabloid = "Tabloid"

instance showOrientation :: Show Orientation where
  show Landscape = "landscape"
  show Portrait = "portrait"

lengthToNumber :: Length -> Number
lengthToNumber (Pixels x) = toNumber x
lengthToNumber (Inches x) = x
lengthToNumber (Centimeters x) = x
lengthToNumber (Millimeters x) = x
