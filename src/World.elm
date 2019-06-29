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
    if
        world
            == { cities = 0
               , crops = 0
               , nature = 0
               }
    then
        { cropYield = 0
        , cropUse = 0
        , productivity = 0
        , co2Offset = 0
        }

    else
        { cropYield = 0
        , cropUse = 1
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
        ([ ( "🍅", worldScore.cropYield )
         , ( "👷\u{200D}♀️", worldScore.productivity )
         , ( "🌬", worldScore.co2Offset )
         ]
            |> List.map
                (\( key, value ) ->
                    Html.div []
                        [ Html.text
                            (key
                                ++ (value |> String.fromInt)
                            )
                        ]
                )
        )
