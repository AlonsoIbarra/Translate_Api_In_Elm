module ElmCss exposing (..)
import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)
import Html.CssHelpers exposing (withNamespace)

type CssClasses
    = NavLink

homepageNamespace =
    withNamespace "homepage"

type CssIds
    = ReactiveLogo
    | BuyTickets

css =
    (stylesheet << namespace homepageNamespace.name)
        [ header
            [ backgroundColor (rgb 90 90 90)
            , boxSizing borderBox
            , padding (px -80)
            , boxShadow5 inset (px 2) (px 3) (px 4) (hex "333")
            ]
        , nav
            [ display inlineBlock
            , paddingBottom (px 12)
            ]
        , class NavLink
            [ margin (px 12)
            , color (rgb 255 255 255)
            ]
        , id ReactiveLogo
            [ display inlineBlock
            , marginLeft (px 150)
            , marginRight (px 80)
            , verticalAlign middle
            ]
        , id BuyTickets
            [ padding (px 16)
            , paddingLeft (px 24)
            , paddingRight (px 24)
            , marginLeft (px 50)
            , marginRight auto
            , color (rgb 255 255 255)
            , backgroundColor (rgb 27 217 130)
            , verticalAlign middle
            ]
        ]