module World exposing (World, init, view)

import Html exposing (Html)


type alias World =
    { nature : Int
    , crops : Int
    , cities : Int
    }


init : World
init =
    { nature = 0
    , crops = 0
    , cities = 0
    }


view : World -> Html msg
view world =
    Html.div []
        (List.map (\string -> Html.div [] [ Html.text string ])
            [ "🌳 -> 0"
            , "🌾 -> 0"
            , "🏢 -> 0"
            ]
        )
