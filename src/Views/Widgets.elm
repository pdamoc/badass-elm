module Views.Widgets exposing (markdown, ionIcon)

import Markdown exposing (defaultOptions)
import Html exposing (Html)
import Html.Attributes as Attr


markdown : String -> Html msg
markdown =
    Markdown.toHtmlWith
        { defaultOptions | defaultHighlighting = Just "elm" }
        [ Attr.class "info-content" ]


ionIcon : String -> Html msg
ionIcon id =
    Html.i [ Attr.class id ] []
