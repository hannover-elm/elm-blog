module Main exposing (main)

import Browser
import Browser.Navigation
import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Http
import Markdown
import Pages.List
import Pages.New
import Pages.Post
import Pages.Utils
import Route exposing (Route)
import Types.Post
import Url exposing (Url)


type Model
    = Loading
    | Page Page
    | NotFound String
    | Error Http.Error


type Page
    = Posts Pages.List.Model
    | Post Pages.Post.Model
    | New Pages.New.Model


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url
    | NewMsg Pages.New.Msg
    | PageChanged (Result Http.Error Page)


main : Program () ( Browser.Navigation.Key, Model ) Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }


init flags url key =
    let
        ( model, cmd ) =
            case Route.fromUrl url of
                Route.Overview ->
                    ( Loading
                    , Cmd.map (PageChanged << Result.map Posts) Pages.List.init
                    )

                Route.Post (Route.PostId postId) ->
                    ( Loading
                    , Cmd.map (PageChanged << Result.map Post) (Pages.Post.init postId)
                    )

                Route.NewPost ->
                    ( Page (New Pages.New.initialModel), Cmd.none )

                Route.NotFound originalUrl ->
                    ( NotFound originalUrl, Cmd.none )
    in
    ( ( key, model ), cmd )


view ( _, model ) =
    { title = ""
    , body =
        [ case model of
            Loading ->
                Pages.Utils.viewLoading

            NotFound originalUrl ->
                Pages.Utils.viewNotFound originalUrl

            Error httpError ->
                Pages.Utils.viewError httpError

            Page (Posts pageModel) ->
                Pages.List.view pageModel

            Page (Post pageModel) ->
                Pages.Post.view pageModel

            Page (New pageModel) ->
                Html.map NewMsg (Pages.New.view pageModel)
        ]
    }


update msg ( key, model ) =
    case ( model, msg ) of
        ( _, UrlRequested (Browser.Internal url) ) ->
            let
                ( newModel, cmd ) =
                    case Route.fromUrl url of
                        Route.Overview ->
                            ( model
                            , Cmd.map (PageChanged << Result.map Posts) Pages.List.init
                            )

                        Route.Post (Route.PostId postId) ->
                            ( model
                            , Cmd.map (PageChanged << Result.map Post)
                                (Pages.Post.init postId)
                            )

                        Route.NewPost ->
                            ( Page (New Pages.New.initialModel), Cmd.none )

                        Route.NotFound originalUrl ->
                            ( NotFound originalUrl, Cmd.none )
            in
            ( ( key, newModel )
            , Cmd.batch
                [ Browser.Navigation.pushUrl key (Url.toString url)
                , cmd
                ]
            )

        ( _, UrlRequested (Browser.External url) ) ->
            ( ( key, model ), Browser.Navigation.load url )

        ( _, UrlChanged _ ) ->
            ( ( key, model ), Cmd.none )

        ( Page (New pageModel), NewMsg pageMsg ) ->
            let
                ( newPageModel, newCmd ) =
                    Pages.New.update pageMsg pageModel
            in
            ( ( key, Page (New newPageModel) ), Cmd.map NewMsg newCmd )

        ( _, NewMsg _ ) ->
            ( ( key, model ), Cmd.none )

        ( _, PageChanged (Ok newPage) ) ->
            ( ( key, Page newPage ), Cmd.none )

        ( _, PageChanged (Err httpError) ) ->
            ( ( key, Error httpError ), Cmd.none )


subscriptions model =
    Sub.none
