module Views.Page exposing (ActivePage(..), frame)

import Html exposing (..)
import Material
import Material.Scheme

import Material.Layout as Layout

type ActivePage
    = Other
    | Home
    | Layout

frame : (Material.Msg msg -> msg) -> Material.Model -> Bool -> ActivePage -> Html (msg) -> Html (msg)
frame msg mdl isLoading activePage body = 
    Layout.render msg mdl
        [ Layout.fixedHeader
        ]
        { header = header activePage
        , drawer = []
        , tabs = ([], [])
        , main = [ body ]
        }
    |> Material.Scheme.top

header : ActivePage -> List (Html msg) 
header page =
    let 
        pageName = case page of 
            Home ->
                " - Home"
            _ ->
                ""
    in
    [ Layout.row [ ] 
        [ Layout.title [] [ text <| "Messageboard" ++ pageName ]
        ]
    ]
