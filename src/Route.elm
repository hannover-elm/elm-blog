module Route exposing (Route(..), fromUrl, toString)

import Url exposing (Url)
import Url.Parser exposing ((</>), map, oneOf, s, string, top)


type Route
    = Posts
    | Post String
    | New
    | NotFound String


toString : Route -> String
toString url =
    case url of
        Posts ->
            "/"

        Post id ->
            "/posts/" ++ id

        New ->
            "/new"

        NotFound originalRoute ->
            originalRoute


fromUrl : Url -> Route
fromUrl url =
    Url.Parser.parse parseUrl url
        |> Maybe.withDefault (NotFound url.path)


parseUrl =
    oneOf
        [ map Post (s "posts" </> string)
        , map Posts top
        , map New (s "new")
        ]
