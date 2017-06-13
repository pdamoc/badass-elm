module Page.Home exposing (view, update, Model, Msg, init)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Html exposing (..)
import Html.Attributes exposing (class, href, id, placeholder, attribute, classList)
import Html.Events exposing (onClick)
import Http
import Task exposing (Task)
import Markdown


-- APP imports

import Data.Sample exposing (Chapter, Sample, getAt)
import Data.Session exposing (Session)
import Request.Sample
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Views.Page as Page
import Util exposing ((=>))
import Views.Assets exposing (ellieFrame)


-- MODEL


type alias Model =
    { chapters : List Chapter
    , selected : ( Chapter, Maybe Sample )
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
            , selected = ( getAt 0 chapters, Nothing )
            }
    in
        Task.map initModel loadChapters
            |> Task.mapError handleLoadError



-- VIEW


view : Session -> Model -> Html Msg
view session model =
    let
        content =
            case model.selected of
                ( chapter, Nothing ) ->
                    viewChapter chapter

                ( chapter, Just sample ) ->
                    viewSample sample
    in
        div []
            [ viewSidebar model
            , content
            ]


viewSidebar model =
    let
        sampleLink chapter sample =
            a
                [ class "list-item sample"
                , onClick (Select chapter (Just sample))
                ]
                [ text sample.title ]

        sampleToItem chapter sample acc =
            acc ++ [ sampleLink chapter sample ]

        chapterLink chapter =
            a
                [ class "list-item chapter"
                , onClick (Select chapter Nothing)
                ]
                [ text chapter.title ]

        chapterToItems chapter acc =
            acc
                ++ [ chapterLink chapter ]
                ++ List.foldl (sampleToItem chapter) [] chapter.samples

        items =
            List.foldl chapterToItems [] model.chapters
    in
        section [ class "sidebar" ]
            [ div [ class "list" ]
                (div [ class "search" ] [] :: items)
            ]


viewChapter chapter =
    section [ class "content" ]
        [ h1 [] [ text chapter.title ]
        , Markdown.toHtml [ class "info-content" ] chapter.content
        ]


viewSample sample =
    section [ class "content" ]
        [ h1 [] [ text sample.title ]
        , Markdown.toHtml [ class "info-content" ] sample.content
        , ellieFrame sample.ellieId
        ]



-- UPDATE


type Msg
    = Select Chapter (Maybe Sample)


update : Session -> Msg -> Model -> ( Model, Cmd Msg )
update session msg model =
    case msg of
        Select idx sample ->
            { model | selected = ( idx, sample ) } => Cmd.none
