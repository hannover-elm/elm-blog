module Types.Post exposing (Post, encodePost, firstParagraph, postDecoder)

import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)


type alias Post =
    { id : String
    , title : String
    , content : String
    }


encodePost : Post -> Value
encodePost post =
    Json.Encode.object
        [ ( "id", Json.Encode.string post.id )
        , ( "title", Json.Encode.string post.title )
        , ( "content", Json.Encode.string post.content )
        ]


postDecoder : Decoder Post
postDecoder =
    Json.Decode.map3 Post
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "content" Json.Decode.string)


examplePost =
    { id = "example-post"
    , title = "Lorem Ipsum"
    , content = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Maecenas ultricies mi eget mauris
pharetra et ultrices neque. Neque gravida in fermentum et sollicitudin ac orci
phasellus egestas. Tortor at risus viverra adipiscing at in tellus integer.
Amet luctus venenatis lectus magna fringilla urna. Tellus id interdum velit
laoreet id. Dictum varius duis at consectetur. Quam id leo in vitae turpis
massa sed elementum. Massa massa ultricies mi quis hendrerit. Eu tincidunt
tortor aliquam nulla. Urna nunc id cursus metus. Iaculis urna id volutpat lacus
laoreet non curabitur. Donec pretium vulputate sapien nec sagittis aliquam
malesuada bibendum arcu. Sem fringilla ut morbi tincidunt augue interdum velit.
Ultricies mi eget mauris pharetra et ultrices neque. Turpis nunc eget lorem
dolor sed viverra. Posuere urna nec tincidunt praesent semper feugiat nibh sed
pulvinar. Turpis tincidunt id aliquet risus.

Semper risus in hendrerit gravida rutrum quisque non. Malesuada fames ac turpis
egestas maecenas. Cursus vitae congue mauris rhoncus. Id aliquet risus feugiat
in. Eu non diam phasellus vestibulum lorem sed risus ultricies. Arcu felis
bibendum ut tristique et. Magna etiam tempor orci eu. Tempus quam pellentesque
nec nam. Enim praesent elementum facilisis leo. Vel pretium lectus quam id leo
in vitae. Viverra adipiscing at in tellus integer feugiat scelerisque varius
morbi. Maecenas volutpat blandit aliquam etiam.  Orci eu lobortis elementum
nibh tellus molestie nunc non. Facilisis volutpat est velit egestas dui id
ornare.

Nisl vel pretium lectus quam id. Ullamcorper velit sed ullamcorper morbi
tincidunt ornare massa eget egestas. Feugiat sed lectus vestibulum mattis
ullamcorper velit. A cras semper auctor neque vitae tempus quam pellentesque
nec. Ac turpis egestas sed tempus urna et. Et netus et malesuada fames. Nisi
vitae suscipit tellus mauris a diam maecenas sed. Amet facilisis magna etiam
tempor orci eu lobortis elementum nibh. Nibh tellus molestie nunc non blandit
massa enim nec. Neque gravida in fermentum et.

Venenatis urna cursus eget nunc scelerisque viverra. Eget arcu dictum varius
duis at consectetur lorem. Tortor pretium viverra suspendisse potenti nullam ac
tortor. Nibh cras pulvinar mattis nunc sed blandit libero. Eget duis at tellus
at urna condimentum. Amet aliquam id diam maecenas. Consequat mauris nunc
congue nisi vitae suscipit tellus mauris. Elit eget gravida cum sociis. Egestas
dui id ornare arcu odio ut. A diam maecenas sed enim ut sem viverra aliquet.
Sit amet cursus sit amet dictum sit. Dictumst vestibulum rhoncus est
pellentesque elit ullamcorper.

Commodo sed egestas egestas fringilla phasellus. Netus et malesuada fames ac
turpis egestas sed. Posuere lorem ipsum dolor sit amet consectetur. Id aliquet
lectus proin nibh. Purus in massa tempor nec feugiat nisl pretium fusce id. Eu
lobortis elementum nibh tellus molestie. Elementum nibh tellus molestie nunc
non blandit. Phasellus egestas tellus rutrum tellus pellentesque eu tincidunt
tortor aliquam. Pretium quam vulputate dignissim suspendisse in est. Elementum
sagittis vitae et leo duis ut. Malesuada fames ac turpis egestas sed tempus.
Turpis nunc eget lorem dolor sed viverra ipsum nunc aliquet. Posuere morbi leo
urna molestie at elementum eu facilisis sed.
"""
    }


firstParagraph blogPost =
    blogPost.content
        |> String.split "\n\n"
        |> List.head
        |> Maybe.withDefault ""
        |> String.left 300
