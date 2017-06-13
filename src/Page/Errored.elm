module Page.Errored exposing (view, pageLoadError, PageLoadError)

{-| The page that renders when there was an error
-}

import Html exposing (Html, main_, h1, div, img, text, p)
import Html.Attributes exposing (class, tabindex, id, alt)
import Data.Session as Session exposing (Session)
import Views.Page as Page exposing (ActivePage)


-- MODEL --


type PageLoadError
    = PageLoadError Model


type alias Model =
    { activePage : ActivePage
    , errorMessage : String
    }


pageLoadError : ActivePage -> String -> PageLoadError
pageLoadError activePage errorMessage =
    PageLoadError { activePage = activePage, errorMessage = errorMessage }



-- VIEW --


view : Session -> PageLoadError -> Html msg
view session (PageLoadError model) =
    main_ [ id "content", class "container", tabindex -1 ]
        [ h1 [] [ text "Error Loading Page" ]
        , div [ class "row" ]
            [ p [] [ text model.errorMessage ] ]
        ]
