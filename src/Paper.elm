module Paper exposing (TreeData(..), data, tree)

import Html exposing (Html, Attribute, node)
import Html.Attributes exposing (property)
import Json.Encode exposing (..)


type TreeData
    = TreeData
        { name : String
        , icon : String
        , open : Bool
        , children : List TreeData
        }


encodeTreeData (TreeData data) =
    object
        [ ( "name", string data.name )
        , ( "icon", string data.icon )
        , ( "open", bool data.open )
        , ( "children", list (List.map encodeTreeData data.children) )
        ]


data : TreeData -> Attribute msg
data treeData =
    property "data" (encodeTreeData treeData)


tree : List (Attribute msg) -> List (Html msg) -> Html msg
tree =
    node "paper-tree"
