module Main exposing (..)

import Html exposing (..)
import Paper exposing (tree, data, TreeData(..))


treeData : TreeData
treeData =
    TreeData
        { name = "Media Center"
        , icon = "weekend"
        , open = True
        , children =
            [ TreeData
                { name = "Movies"
                , icon = "av:movie"
                , open = True
                , children =
                    [ TreeData
                        { name = "Interstellar"
                        , icon = "theaters"
                        , open = True
                        , children = []
                        }
                    , TreeData
                        { name = "The Godfather"
                        , icon = "theaters"
                        , open = True
                        , children = []
                        }
                    , TreeData
                        { name = "Pulp Fiction"
                        , icon = "theaters"
                        , open = True
                        , children = []
                        }
                    ]
                }
            , TreeData
                { name = "TV Shows"
                , icon = "notification:live-tv"
                , open = True
                , children =
                    [ TreeData
                        { name = "Breaking Bad"
                        , icon = "theaters"
                        , open = True
                        , children = []
                        }
                    , TreeData
                        { name = "Game of Thrones"
                        , icon = "theaters"
                        , open = True
                        , children = []
                        }
                    ]
                }
            ]
        }


main : Html msg
main =
    tree [ data treeData ] []
