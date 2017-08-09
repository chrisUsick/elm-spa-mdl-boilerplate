module Views.Page exposing (ActivePage(..), frame)

import Html exposing (..)
import Html.Attributes exposing (class)

type ActivePage
    = Other
    | Home

frame : Bool -> ActivePage -> Html msg -> Html msg
frame isLoading page content =
    div [ class "page-frame" ]
        [ viewHeader page isLoading
        , content 
        ]

viewHeader : ActivePage -> Bool -> Html msg 
viewHeader page isLoading =
    div []
        [ if isLoading then text "Loading" else text "Loaded" ]


