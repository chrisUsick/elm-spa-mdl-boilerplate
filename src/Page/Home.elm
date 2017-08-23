module Page.Home exposing (Model, Msg, init, update, view)

import Task as Task
import Task exposing (Task)
import Html exposing (..)
import Util exposing (..)
import Page.Errored exposing (PageLoadError)
import Material
import Material.Button as Button
import Material.Options as Options

type alias Model = 
    { word : String
    , mdl : Material.Model
    }
init : Task PageLoadError Model
init = 
    Task.succeed (Model "Hello world" Material.model)

view : Model -> Html Msg
view model =
    div []
        [ text model.word 
        , Button.render Mdl
            [ 2 ]
            model.mdl
            [ Options.onClick Concat ]
            [ text "Add counter" ]
        ]

-- UPDATE --

type Msg 
    = NoMsg
    | Concat 
    | Mdl (Material.Msg Msg)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case msg of 
        NoMsg ->
            model => Cmd.none
        Mdl msg_ ->
            Material.update Mdl msg_ model
        Concat ->
            { model | word = model.word ++ model.word } => Cmd.none
