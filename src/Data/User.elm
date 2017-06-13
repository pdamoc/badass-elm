module Data.User exposing (User, decoder)

import Util exposing ((=>))
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Json.Encode as Encode exposing (Value)


type alias User =
    { name : String
    }



-- SERIALIZATION --


decoder : Decoder User
decoder =
    decode User
        |> required "name" Decode.string


encode : User -> Value
encode user =
    Encode.object
        [ "name" => Encode.string user.name
        ]
