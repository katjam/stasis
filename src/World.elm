module World exposing (World, WorldChange, aggregate, init, score, view)

import Html exposing (Html)


type alias World =
    List WorldChange


type alias WorldChange =
    { nature : Int
    , crops : Int
    , cities : Int
    }


init : WorldChange
init =
    { nature = 3
    , crops = 2
    , cities = 1
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
    List.map scoreForWorldChange world
        |> List.foldl
            (\worldChange scoreSoFar ->
                { co2Offset =
                    scoreSoFar.co2Offset
                        + worldChange.co2Offset
                , cropYield =
                    scoreSoFar.cropYield
                        + worldChange.cropYield
                , productivity =
                    scoreSoFar.productivity
                        + worldChange.productivity
                , cropUse =
                    scoreSoFar.cropUse
                        + worldChange.cropUse
                }
            )
            zeroScore


zeroScore : Score
zeroScore =
    { co2Offset = 0, cropYield = 0, productivity = 0, cropUse = 0 }


scoreForWorldChange : WorldChange -> Score
scoreForWorldChange worldChange =
    { cropYield = worldChange.crops
    , cropUse = worldChange.cities
    , productivity = worldChange.cities * 3
    , co2Offset =
        worldChange.nature
            * 2
            - (worldChange.cities + worldChange.crops)
    }


view : WorldChange -> World -> Html msg
view stagedWorldChange world =
    Html.div []
        (scoreView (score world)
            :: List.map (\string -> Html.div [] [ Html.text string ])
                [ "🌳 -> "
                    ++ String.fromInt (aggregate world |> .nature)
                    ++ " ("
                    ++ String.fromInt
                        stagedWorldChange.nature
                    ++ ")"
                , "🌾 -> 0 ("
                    ++ String.fromInt
                        stagedWorldChange.crops
                    ++ ")"
                , "🏢 -> 0 ("
                    ++ String.fromInt
                        stagedWorldChange.cities
                    ++ ")"
                ]
        )


aggregate : World -> WorldChange
aggregate world =
    world
        |> List.foldl aggregatorThing
            { cities = 0
            , crops = 0
            , nature = 0
            }


aggregatorThing : WorldChange -> WorldChange -> WorldChange
aggregatorThing worldChange changeSoFar =
    { cities =
        worldChange.cities
            + changeSoFar.cities
    , crops =
        worldChange.crops
            + changeSoFar.crops
    , nature =
        worldChange.nature
            + changeSoFar.nature
    }


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
