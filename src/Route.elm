module Route exposing (Route(..), href, modifyUrl, fromLocation)

import UrlParser as Url exposing (parseHash, s, (</>), string, oneOf, Parser)
import Navigation exposing (Location)
import Html exposing (Attribute)
import Html.Attributes as Attr


-- ROUTING --


type Route
    = Home


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home (s "")
        ]



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []
    in
        "#/" ++ (String.join "/" pieces)



-- PUBLIC HELPERS --


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Home
    else
        parseHash route location
