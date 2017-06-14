module Views.Widgets exposing (markdown)

import Markdown exposing (defaultOptions)
import Html exposing (Html)
import Html.Attributes as Attr


markdown : String -> Html msg
markdown =
    Markdown.toHtmlWith
        { defaultOptions | defaultHighlighting = Just "elm" }
        [ Attr.class "info-content" ]
