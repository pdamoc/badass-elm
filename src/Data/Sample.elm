module Data.Sample exposing (Chapter, Sample, chapterDecoder, getAt)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, custom, hardcoded)
import List.Extra


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
