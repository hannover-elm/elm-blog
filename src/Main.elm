module Main exposing (main)

import Browser
import Browser.Navigation exposing (Key)
import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Http
import Markdown
import Pages.New
import Pages.Post
import Pages.Posts
import Pages.Utils
import Route exposing (Route)
import Types.Post
import Url exposing (Url)


type alias Model =
    { key : Browser.Navigation.Key
    , page : Page
    }


type Page
    = Loading
    | PostsPage Pages.Posts.Model
    | PostPage Pages.Post.Model
    | NewPage Pages.New.Model
    | NotFoundPage String
    | ErrorPage Http.Error


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url
    | PageChanged (Result Http.Error Page)
    | NewPageMsg Pages.New.Msg


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( page, cmd ) =
            case Route.fromUrl url of
                Route.Posts ->
                    ( Loading
                    , Cmd.map (PageChanged << Result.map PostsPage) Pages.Posts.init
                    )

                Route.Post postId ->
                    ( Loading
                    , Cmd.map (PageChanged << Result.map PostPage) (Pages.Post.init postId)
                    )

                Route.New ->
                    ( NewPage Pages.New.initialModel, Cmd.none )

                Route.NotFound originalUrl ->
                    ( NotFoundPage originalUrl, Cmd.none )
    in
    ( { key = key, page = page }, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( model.page, msg ) of
        ( _, UrlRequested (Browser.Internal url) ) ->
            ( model, Browser.Navigation.pushUrl model.key (Url.toString url) )

        ( _, UrlRequested (Browser.External url) ) ->
            ( model, Browser.Navigation.load url )

        ( _, UrlChanged url ) ->
            let
                ( newPage, cmd ) =
                    case Route.fromUrl url of
                        Route.Posts ->
                            ( model.page
                            , Cmd.map (PageChanged << Result.map PostsPage)
                                Pages.Posts.init
                            )

                        Route.Post postId ->
                            ( model.page
                            , Cmd.map (PageChanged << Result.map PostPage)
                                (Pages.Post.init postId)
                            )

                        Route.New ->
                            ( NewPage Pages.New.initialModel, Cmd.none )

                        Route.NotFound originalUrl ->
                            ( NotFoundPage originalUrl, Cmd.none )
            in
            ( { model | page = newPage }, cmd )

        ( NewPage pageModel, NewPageMsg pageMsg ) ->
            let
                ( newPageModel, newCmd ) =
                    Pages.New.update pageMsg pageModel
            in
            ( { model | page = NewPage newPageModel }, Cmd.map NewPageMsg newCmd )

        ( _, NewPageMsg _ ) ->
            ( model, Cmd.none )

        ( _, PageChanged (Ok newPage) ) ->
            ( { model | page = newPage }, Cmd.none )

        ( _, PageChanged (Err httpError) ) ->
            ( { model | page = ErrorPage httpError }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "elm-blog"
    , body =
        [ case model.page of
            Loading ->
                Pages.Utils.viewLoading

            NotFoundPage originalUrl ->
                Pages.Utils.viewNotFound originalUrl

            ErrorPage httpError ->
                Pages.Utils.viewError httpError

            PostsPage pageModel ->
                Pages.Posts.view pageModel

            PostPage pageModel ->
                Pages.Post.view pageModel

            NewPage pageModel ->
                Html.map NewPageMsg (Pages.New.view pageModel)
        ]
    }
