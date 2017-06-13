module Page.Home exposing (view, update, Model, Msg, init)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Html exposing (..)
import Html.Attributes exposing (class, href, id, placeholder, attribute, classList)
import Http
import Task exposing (Task)


-- APP imports

import Data.Sample exposing (Chapter, Sample)
import Data.Session exposing (Session)
import Request.Sample
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Views.Page as Page
import Util exposing ((=>))


type alias Model =
    { chapters : List Chapter
    , selected : ( Int, Maybe Sample )
    }


init : Session -> Task PageLoadError Model
init session =
    let
        loadChapters =
            Request.Sample.loadChapters
                |> Http.toTask

        handleLoadError _ =
            pageLoadError Page.Home "Homepage is currently unavailable."

        initModel chapters =
            { chapters = chapters
            , selected = ( 0, Nothing )
            }
    in
        Task.map initModel loadChapters
            |> Task.mapError handleLoadError



-- VIEW


view : Session -> Model -> Html Msg
view session model =
    h1 [] [ text "Hello Homepage" ]



-- UPDATE


type Msg
    = Select Int (Maybe Sample)


update : Session -> Msg -> Model -> ( Model, Cmd Msg )
update session msg model =
    case msg of
        Select idx sample ->
            { model | selected = ( idx, sample ) } => Cmd.none
