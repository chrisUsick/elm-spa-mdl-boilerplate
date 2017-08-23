module Main exposing (main)

import Json.Decode as Decode exposing (Value)
import Navigation exposing (Location)
import Route exposing (Route)
import Html exposing (..)
import Util exposing ((=>))
import Page.Home as Home
import Page.Errored as Errored exposing (PageLoadError)
import Views.Page as Page exposing (ActivePage)
import Task as Task
import Material

type Page
    = Blank
    | NotFound
    | Home Home.Model
    | Errored PageLoadError

type PageState
    = Loaded Page
    | TransitioningFrom Page

-- MODEL --


type alias Model =
    { pageState : PageState
    , mdl : Material.Model
    }


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    setRoute (Route.fromLocation location)
        <| Model (Loaded initialPage) (Material.model)

initialPage : Page
initialPage =
    Blank

view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage False page model

        TransitioningFrom page ->
            viewPage True page model

viewPage :  Bool -> Page -> Model -> Html Msg
viewPage isLoading page model =
    let
        frame =
            Page.frame Mdl model.mdl isLoading
    in
    case page of
        NotFound ->
            Html.text "Not found"
                |> frame Page.Other
        Blank ->
            -- This is for the very initial page load, while we are loading
            -- data via HTTP. We could also render a spinner here.
            Html.text "haza"
                |> frame Page.Other
        Home subModel ->
                Home.view subModel
                |> Html.map HomeMsg
                |> frame Page.Home
        Errored subModel ->
            Errored.view subModel
                |> frame Page.Other


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ pageSubscriptions (getPage model.pageState)
        ]



getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


pageSubscriptions : Page -> Sub Msg
pageSubscriptions page =
    case page of
        Blank ->
            Sub.none
        NotFound ->
            Sub.none
        Home _ -> 
            Sub.none
        Errored _ ->
            Sub.none
        

-- UPDATE

type Msg 
    = SetRoute (Maybe Route)
    | HomeLoaded (Result PageLoadError Home.Model)
    | HomeMsg Home.Msg
    | Mdl (Material.Msg Msg)

setRoute : Maybe Route -> Model -> (Model, Cmd Msg)
setRoute maybeRoute model = 
    let
        transition toMsg task =
            { model | pageState = TransitioningFrom (getPage model.pageState) }
                => Task.attempt toMsg task
    in
    case maybeRoute of 
        Nothing ->
            { model | pageState = Loaded NotFound } => Cmd.none
        Just Route.Home ->
            transition HomeLoaded Home.init

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    let 
        toPage toModel toMsg subUpdate subMsg subModel = 
            let 
                (newModel, newCmd ) =
                    subUpdate subMsg subModel
            in 
                { model | pageState = Loaded (toModel newModel) } => Cmd.map toMsg newCmd
    in
    case (msg, page) of 
        (SetRoute route, _ ) ->
            setRoute route model 
        (HomeLoaded (Ok subModel), page) ->
            { model | pageState = Loaded (Home subModel) } => Cmd.none
        (HomeLoaded (Err error), page) ->
            { model | pageState = Loaded (Errored error) } => Cmd.none
        ( HomeMsg subMsg, Home subModel ) ->
            toPage Home HomeMsg (Home.update) subMsg subModel
        (_, NotFound) ->
            -- Disregard incoming messages when we're on the
            -- NotFound page.
            model => Cmd.none
        ( _, _ ) ->
            -- Disregard incoming messages that arrived for the wrong page
            model => Cmd.none



-- MAIN --


main : Program Value Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }