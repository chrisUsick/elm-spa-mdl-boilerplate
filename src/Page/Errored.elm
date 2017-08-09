module Page.Errored exposing (PageLoadError, pageLoadError, view)

import Views.Page as Page exposing (ActivePage)
import Html exposing (Html, div, h1, img, main_, p, text)
import Html.Attributes exposing (alt, class, id, tabindex)


type PageLoadError
    = PageLoadError Model

type alias Model = 
    { activePage : ActivePage
    , errorMessage : String
    }

pageLoadError : ActivePage -> String -> PageLoadError
pageLoadError activePage errorMessage =
    PageLoadError { activePage = activePage, errorMessage = errorMessage }


-- VIEW --

view : PageLoadError -> Html msg
view (PageLoadError model) =
    main_ [ id "content", class "container", tabindex -1 ]
        [ h1 [] [ text "Error Loading Page" ]
        , div [ class "row" ]
            [ p [] [ text model.errorMessage ] ]
        ]

