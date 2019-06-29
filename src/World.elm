module World exposing (World, init, score, view)

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


type alias Score =
    { co2Offset : Int
    , cropYield : Int
    , productivity : Int
    , cropUse : Int
    }


score :
    World
    -> Score
score world =
    { cropYield = world.crops
    , cropUse = world.cities
    , productivity = world.cities * 3
    , co2Offset = 0
    }


view : World -> Html msg
view world =
    Html.div []
        (scoreView (score world)
            :: List.map (\string -> Html.div [] [ Html.text string ])
                [ "🌳 -> 0"
                , "🌾 -> 0"
                , "🏢 -> 0"
                ]
        )


scoreView : Score -> Html msg
scoreView worldScore =
    Html.div []
        ([ ( "🍅"
           , (worldScore.cropUse |> String.fromInt)
                ++ "/"
                ++ (worldScore.cropYield |> String.fromInt)
           )
         , ( "👷\u{200D}♀️", worldScore.productivity |> String.fromInt )
         , ( "🌬", worldScore.co2Offset |> String.fromInt )
         ]
            |> List.map
                (\( key, value ) ->
                    Html.div []
                        [ Html.text
                            (key
                                ++ value
                            )
                        ]
                )
        )
