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
import Util exposing (findTerms)


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
    , content = "Could not find any example matching your terms"
    , samples = []
    }


filterChapters : String -> List Chapter -> List Chapter
filterChapters terms chapters =
    case filterChapters_ terms chapters of
        [] ->
            -- there should always be something to display.
            [ noResults ]

        xs ->
            xs


sampleShouldStay : String -> Sample -> Bool
sampleShouldStay terms sample =
    findTerms terms sample.title
        || findTerms terms sample.content


chapterShouldStay : String -> Chapter -> Maybe Chapter
chapterShouldStay terms chapter =
    let
        samples =
            List.filter (sampleShouldStay terms) chapter.samples
    in
        if
            findTerms terms chapter.title
                || findTerms terms chapter.content
                || (List.length samples > 0)
        then
            Just { chapter | samples = samples }
        else
            Nothing


filterChapters_ : String -> List Chapter -> List Chapter
filterChapters_ terms chapters =
    List.filterMap (chapterShouldStay terms) chapters


findFirstSample : String -> List Sample -> Maybe Sample
findFirstSample terms samples =
    case samples of
        [] ->
            Nothing

        x :: xs ->
            if
                findTerms terms x.title
                    || findTerms terms x.content
            then
                Just x
            else
                findFirstSample terms xs


findFirstMatch : String -> Chapter -> ( Chapter, Maybe Sample )
findFirstMatch terms chapter =
    if
        findTerms terms chapter.title
            || findTerms terms chapter.content
    then
        ( chapter, Nothing )
    else
        ( chapter, findFirstSample terms chapter.samples )


selectSample : String -> List Chapter -> ( Chapter, Maybe Sample )
selectSample terms chapters =
    case (filterChapters_ terms chapters) of
        [] ->
            ( noResults, Nothing )

        x :: xs ->
            findFirstMatch terms x


safeHead : List Chapter -> Chapter
safeHead list =
    List.head list
        |> Maybe.withDefault noResults
