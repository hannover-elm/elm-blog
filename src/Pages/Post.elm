module Pages.Post exposing (Model, init, update, view)

import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Http
import Markdown
import Pages.Utils exposing (viewBreadcrumb, viewPage)
import Route exposing (Route)
import Types.Post exposing (Post, postDecoder)


type alias Model =
    { post : Post
    }


type Msg
    = NoOp


init : String -> Cmd (Result Http.Error Model)
init id =
    Http.get
        { url = "/api/post/" ++ id
        , expect = Http.expectJson (Result.map Model) postDecoder
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view model =
    viewPage
        [ Html.div [ class "blog-post" ]
            [ viewBreadcrumb [] model.post.title
            , Html.h2 [ class "blog-post__headline" ]
                [ text model.post.title ]
            , Markdown.toHtml [ class "blog-post__content" ] model.post.content
            ]
        ]
