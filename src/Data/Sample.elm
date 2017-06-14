module Data.Sample
    exposing
        ( Chapter
        , Sample
        , chapterDecoder
        , getAt
        , filterChapters
        , selectSample
        , safeHead
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, custom, hardcoded)
import List.Extra
import Util exposing (caselessContain)


type alias Chapter =
    { title : String
    , content : String
    , samples : List Sample
    }


getAt : Int -> List Chapter -> Chapter
getAt idx list =
    List.Extra.getAt idx list
        |> Maybe.withDefault (Chapter "Empty" "noContent" [])


type alias Sample =
    { title : String
    , description : String
    , content : String
    , ellieId : String
    }


chapterDecoder : Decoder Chapter
chapterDecoder =
    decode Chapter
        |> required "title" (Decode.map (Maybe.withDefault "") (Decode.nullable Decode.string))
        |> required "content" (Decode.map (Maybe.withDefault "") (Decode.nullable Decode.string))
        |> required "samples" (Decode.list sampleDecoder)


sampleDecoder : Decoder Sample
sampleDecoder =
    decode Sample
        |> required "title" (Decode.map (Maybe.withDefault "") (Decode.nullable Decode.string))
        |> required "description" (Decode.map (Maybe.withDefault "") (Decode.nullable Decode.string))
        |> required "content" (Decode.map (Maybe.withDefault "") (Decode.nullable Decode.string))
        |> required "ellie-id" (Decode.map (Maybe.withDefault "") (Decode.nullable Decode.string))


noResults : Chapter
noResults =
    { title = "No sample matching"
    , content = "Could not find any example matching your search"
    , samples = []
    }


filterChapters : String -> List Chapter -> List Chapter
filterChapters search chapters =
    case filterChapters_ search chapters of
        [] ->
            -- there should always be something to display.
            [ noResults ]

        xs ->
            xs


sampleShouldStay : String -> Sample -> Bool
sampleShouldStay search sample =
    caselessContain search sample.title
        || caselessContain search sample.content


chapterShouldStay : String -> Chapter -> Maybe Chapter
chapterShouldStay search chapter =
    let
        samples =
            List.filter (sampleShouldStay search) chapter.samples
    in
        if
            caselessContain search chapter.title
                || caselessContain search chapter.content
                || (List.length samples > 0)
        then
            Just { chapter | samples = samples }
        else
            Nothing


filterChapters_ : String -> List Chapter -> List Chapter
filterChapters_ search chapters =
    List.filterMap (chapterShouldStay search) chapters


findFirstSample search samples =
    case samples of
        [] ->
            Nothing

        x :: xs ->
            if
                caselessContain search x.title
                    || caselessContain search x.content
            then
                Just x
            else
                findFirstSample search xs


findFirstMatch search chapter =
    if
        caselessContain search chapter.title
            || caselessContain search chapter.content
    then
        ( chapter, Nothing )
    else
        ( chapter, findFirstSample search chapter.samples )


selectSample : String -> List Chapter -> ( Chapter, Maybe Sample )
selectSample search chapters =
    case (filterChapters_ search chapters) of
        [] ->
            ( noResults, Nothing )

        x :: xs ->
            findFirstMatch search x


safeHead : List Chapter -> Chapter
safeHead list =
    List.head list
        |> Maybe.withDefault noResults
