module Pages.Utils exposing
    ( viewBreadcrumb
    , viewError
    , viewLoading
    , viewNotFound
    , viewPage
    )

import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Http
import Markdown
import Route exposing (Route)
import Url exposing (Url)


viewPage : List (Html msg) -> Html msg
viewPage nodes =
    Html.div [ class "main" ]
        [ Html.h1 [ class "logo" ] [ text "elm-blog" ]
        , Html.div [ class "page" ] nodes
        ]


viewBreadcrumb : List ( Route, String ) -> String -> Html msg
viewBreadcrumb urlParts finalPart =
    let
        viewRoutePart ( url, string ) =
            Html.a [ Html.Attributes.href (Route.toString url) ] [ text string ]

        viewFinalPart string =
            Html.span [] [ text string ]
    in
    Html.div [ class "blog-post__breadcrumb" ]
        (Html.a [ Html.Attributes.href (Route.toString Route.Posts) ] [ text "/" ]
            :: text " "
            :: ((List.map viewRoutePart urlParts ++ [ viewFinalPart finalPart ])
                    |> List.intersperse (text " / ")
               )
        )


viewLoading : Html msg
viewLoading =
    viewPage [ Html.h1 [] [ text "Loading" ] ]


viewNotFound : String -> Html msg
viewNotFound originalUrl =
    viewPage
        [ Html.h1 [] [ text "NTO FNUOD!" ]
        , Html.span [] [ text originalUrl ]
        ]


viewError : Http.Error -> Html msg
viewError httpError =
    viewPage
        [ Html.h1 [] [ text "Error" ]
        , Html.span []
            [ case httpError of
                Http.BadUrl url ->
                    text ("Bad URL: " ++ url)

                Http.Timeout ->
                    text "Timeout"

                Http.NetworkError ->
                    text "Network error"

                Http.BadStatus status ->
                    text ("Bad status: " ++ String.fromInt status)

                Http.BadBody body ->
                    text ("Unexpected response: " ++ body)
            ]
        ]
