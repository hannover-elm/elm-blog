module Pages.List exposing (Model, init, view)

import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Http
import Json.Decode
import Markdown
import Pages.Utils exposing (viewBreadcrumb, viewPage)
import Route exposing (Route)
import Types.Post as Post exposing (Post, postDecoder)


type alias Model =
    { posts : List Post }


init : Cmd (Result Http.Error Model)
init =
    Http.get
        { url = "/api/post"
        , expect = Http.expectJson (Result.map Model) (Json.Decode.list postDecoder)
        }


view model =
    viewPage
        [ viewBreadcrumb Route.Overview
        , Html.div [ class "posts" ]
            (List.map viewPostItem model.posts)
        , Html.a
            [ class "new-post"
            , Html.Attributes.href (Route.toString Route.NewPost)
            ]
            [ text "New Post" ]
        ]


viewPostItem post =
    let
        url =
            Route.toString (Route.Post (Route.PostId post.id))
    in
    Html.a
        [ class "post-item"
        , Html.Attributes.href url
        ]
        [ Html.h2 [ class "post-item__headline" ]
            [ text post.title ]
        , Markdown.toHtml [ class "post-item__content" ]
            (Post.firstParagraph post ++ "…")
        , Html.a
            [ class "post-item__read-more"
            , Html.Attributes.href url
            ]
            [ text "Read more" ]
        ]
