module Page.Home exposing (Model, Msg, init, update, view)

import Task as Task
import Task exposing (Task)
import Html exposing (..)
import Util exposing (..)
import Page.Errored exposing (PageLoadError)

type alias Model = 
    { word : String }
init : Task PageLoadError Model
init = 
    Task.succeed (Model "Hello world")

view : Model -> Html Msg
view model =
    div []
        [ text model.word ]

-- UPDATE --

type Msg 
    = NoMsg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case msg of 
        NoMsg ->
            model => Cmd.none
