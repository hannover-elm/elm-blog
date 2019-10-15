module Route exposing (PostId(..), Route(..), fromUrl, toString)

import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, map, oneOf, s, string, top)


type Route
    = Overview
    | Post PostId
    | NewPost
    | NotFound String


type PostId
    = PostId String


toString : Route -> String
toString url =
    case url of
        Overview ->
            "/"

        Post (PostId id) ->
            "/posts/" ++ id

        NewPost ->
            "/new"

        NotFound originalRoute ->
            originalRoute


fromUrl : Url -> Route
fromUrl url =
    Url.Parser.parse parseUrl url
        |> Maybe.withDefault (NotFound url.path)


parseUrl : Parser (Route -> a) a
parseUrl =
    oneOf
        [ map (Post << PostId) (s "posts" </> string)
        , map NewPost (s "new")
        , map Overview top
        ]
