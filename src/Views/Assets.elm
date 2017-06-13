module Views.Assets exposing (notFound, src, ellieFrame)

{-| Assets, such as images, videos, and audio. (We only have images for now.)

We should never expose asset URLs directly; this module should be in charge of
all of them. One source of truth!

-}

import Html exposing (Html, Attribute, iframe)
import Html.Attributes as Attr
import Util exposing ((=>))


type Image
    = Image String



-- IMAGES --


notFound : Image
notFound =
    Image "/img/not_found.png"



-- USING IMAGES --


src : Image -> Attribute msg
src (Image url) =
    Attr.src url


ellieFrameStyle : List ( String, String )
ellieFrameStyle =
    [ "width" => "100%", "height" => "400px", "border" => "0", "border-radius" => " 3px", "overflow" => "hidden;" ]


ellieFrame : String -> Html msg
ellieFrame ellieId =
    iframe
        [ Attr.src ("https://embed.ellie-app.com/" ++ ellieId)
        , Attr.style ellieFrameStyle
        , Attr.sandbox "allow-modals allow-forms allow-popups allow-scripts allow-same-origin"
        ]
        []
