module Util exposing ((=>), caselessContain)


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


{-| infixl 0 means the (=>) operator has the same precedence as (<|) and (|>),
meaning you can use it at the end of a pipeline and have the precedence work out.
-}
infixl 0 =>


caselessContain : String -> String -> Bool
caselessContain term str =
    String.contains (String.toLower term) (String.toLower str)
