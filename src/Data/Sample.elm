module Data.Sample exposing (Chapter, Sample, chapterDecoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, custom, hardcoded)


type alias Chapter =
    { title : String
    , content : String
    , samples : List Sample
    }


type alias Sample =
    { title : String
    , description : String
    , content : String
    , ellieLink : String
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
        |> required "ellieLink" (Decode.map (Maybe.withDefault "") (Decode.nullable Decode.string))
