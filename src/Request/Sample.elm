module Request.Sample exposing (loadChapters)

import Http
import Data.Sample as Sample exposing (Chapter)
import Json.Decode as Decode


loadChapters : Http.Request (List Chapter)
loadChapters =
    Decode.field "chapters" (Decode.list Sample.chapterDecoder)
        |> Http.get "data.json"
