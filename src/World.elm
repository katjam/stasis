module World exposing (World, init, view)

import Html exposing (Html)


type alias World =
    List (List (Maybe ()))


init : World
init =
    [ [ Nothing, Nothing, Nothing ]
    , [ Nothing, Nothing, Nothing ]
    , [ Nothing, Nothing, Nothing ]
    ]


view : World -> Html msg
view world =
    Html.text "🏔️"



-- 🏔️
