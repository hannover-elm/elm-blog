module Pages.Utils exposing
    ( viewBreadcrumb
    , viewError
    , viewLoading
    , viewNotFound
    , viewPage
    )

import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Markdown
import Route exposing (Route)


viewPage nodes =
    Html.div [ class "main" ]
        [ Html.h1 [ class "logo" ] [ text "elm-blog" ]
        , Html.div [ class "page" ] nodes
        ]


viewBreadcrumb url =
    case url of
        Route.Posts ->
            viewBreadcrumbCustom [] "Posts"

        Route.Post postId ->
            viewBreadcrumbCustom [ ( Route.Posts, "Posts" ) ] postId

        Route.New ->
            viewBreadcrumbCustom [] "New Post"

        Route.NotFound originalRoute ->
            viewBreadcrumbCustom [] originalRoute


viewBreadcrumbCustom : List ( Route, String ) -> String -> Html msg
viewBreadcrumbCustom urlParts finalPart =
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


viewNotFound originalUrl =
    viewPage
        [ Html.h1 [] [ text "NTO FNUOD!" ]
        , Html.span [] [ text originalUrl ]
        ]


viewError httpError =
    viewPage
        [ Html.h1 [] [ text "HCF" ]
        , Html.span [] [ text "I'm hurt!" ]
        ]


viewLoading =
    viewPage
        [ Html.h1 [] [ text "Loading" ]
        ]
