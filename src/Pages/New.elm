module Pages.New exposing (Model, Msg, initialModel, update, view)

import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Html.Events
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Pages.Utils exposing (viewBreadcrumb, viewPage)
import Route exposing (Route)
import Types.Post exposing (Post, encodePost, postDecoder)


type alias Model =
    { title : String
    , content : String
    }


fileName title =
    (String.trim title ++ ".md")
        |> String.replace " " "-"
        |> String.toLower


initialModel : Model
initialModel =
    { title = ""
    , content = ""
    }


type Msg
    = TitleChanged String
    | ContentChanged String
    | SaveClicked
    | PostSaved (Result Http.Error Post)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TitleChanged newTitle ->
            ( { model | title = newTitle }, Cmd.none )

        ContentChanged newContent ->
            ( { model | content = newContent }, Cmd.none )

        SaveClicked ->
            ( model
            , Http.post
                { url = "/api/post"
                , body =
                    Http.jsonBody
                        (encodePost
                            { id = fileName model.title
                            , title = String.trim model.title
                            , content = String.trim model.content
                            }
                        )
                , expect = Http.expectJson PostSaved postDecoder
                }
            )

        PostSaved _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        saveDisabled =
            String.trim model.title == "" || String.trim model.content == ""
    in
    viewPage
        [ viewBreadcrumb Route.NewPost
        , Html.div [ class "post-form" ]
            [ Html.div [ class "post-form__inputs" ]
                [ Html.label []
                    [ text "Filename*" ]
                , Html.input
                    [ Html.Attributes.disabled True
                    , Html.Attributes.value (fileName model.title)
                    ]
                    []
                , Html.label []
                    [ text "Title*" ]
                , Html.input [ Html.Events.onInput TitleChanged ] []
                , Html.label []
                    [ text "Text*" ]
                , Html.textarea [ Html.Events.onInput ContentChanged ] []
                ]
            , Html.div [ class "post-form__actions" ]
                [ Html.button
                    [ Html.Attributes.disabled saveDisabled
                    , Html.Events.onClick SaveClicked
                    ]
                    [ text "Speichern" ]
                ]
            ]
        ]
