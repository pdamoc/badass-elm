module Page.Home exposing (view, update, Model, Msg, init)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Html exposing (..)
import Html.Attributes exposing (class, href, id, placeholder, attribute, classList)
import Html.Events exposing (onClick, onInput)
import Http
import Task exposing (Task)


-- APP imports

import Data.Sample exposing (Chapter, Sample, getAt, filterChapters, selectSample, safeHead)
import Data.Session exposing (Session)
import Request.Sample
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Views.Page as Page
import Util exposing ((=>))
import Views.Assets exposing (ellieFrame)
import Views.Widgets exposing (markdown, ionIcon)


-- MODEL


type alias Model =
    { chapters : List Chapter
    , selected : ( Chapter, Maybe Sample )
    , searchField : String
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
            , searchField = ""
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
        ( selectedChapter, selectedSample ) =
            model.selected

        sampleLink chapter sample =
            a
                [ class
                    (if chapter == selectedChapter && selectedSample == (Just sample) then
                        "list-item sample active"
                     else
                        "list-item sample"
                    )
                , onClick (Select chapter (Just sample))
                ]
                [ text sample.title ]

        sampleToItem chapter sample acc =
            acc ++ [ sampleLink chapter sample ]

        chapterLink chapter =
            a
                [ class
                    (if chapter == selectedChapter && selectedSample == Nothing then
                        "list-item chapter active"
                     else
                        "list-item chapter"
                    )
                , onClick (Select chapter Nothing)
                ]
                [ text chapter.title ]

        chapterToItems chapter acc =
            acc
                ++ [ chapterLink chapter ]
                ++ List.foldl (sampleToItem chapter) [] chapter.samples

        filteredChapters =
            case model.searchField of
                "" ->
                    model.chapters

                search ->
                    filterChapters search model.chapters

        items =
            List.foldl chapterToItems [] filteredChapters
    in
        section [ class "sidebar" ]
            [ div [ class "list" ]
                (div [ class "sidebar_head" ]
                    [ h3 [ class "clearfix" ] [ text "Badass Elm" ]
                    , div [ class "search-wrapper" ]
                        [ input [ onInput Filter ] [] ]
                    ]
                    :: items
                )
            , div [ class "footer-clear" ] []
            ]


viewChapter chapter =
    section [ class "content" ]
        [ h1 [] [ text chapter.title ]
        , markdown chapter.content
        , div [ class "footer-clear" ] []
        ]


viewSample sample =
    section [ class "content" ]
        [ h1 [] [ text sample.title ]
        , markdown sample.content
        , ellieFrame sample.ellieId
        , div [ class "footer-clear" ] []
        ]



-- UPDATE


type Msg
    = Select Chapter (Maybe Sample)
    | Filter String


update : Session -> Msg -> Model -> ( Model, Cmd Msg )
update session msg model =
    case msg of
        Select idx sample ->
            { model | selected = ( idx, sample ) } => Cmd.none

        Filter str ->
            let
                selected =
                    case str of
                        "" ->
                            ( safeHead model.chapters, Nothing )

                        _ ->
                            selectSample str model.chapters
            in
                { model | searchField = str, selected = selected } => Cmd.none
