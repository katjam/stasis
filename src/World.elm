module World exposing (AddResource(..), World, WorldChange, aggregate, init, score, view)

import Html exposing (..)
import Html.Events


type alias World =
    List WorldChange


type alias WorldChange =
    { nature : Int
    , crops : Int
    , cities : Int
    }


init : World
init =
    [ { nature = 0
      , crops = 0
      , cities = 0
      }
    ]


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


view : WorldChange -> World -> Html AddResource
view stagedWorldChange world =
    Html.div []
        [ scoreView (score world)
        , resourceView "🌳" .nature stagedWorldChange world
        , resourceView "🌾" .crops stagedWorldChange world
        , resourceView "🏢" .cities stagedWorldChange world
        ]


type AddResource
    = Nature
    | Crop
    | City


resourceView : String -> (WorldChange -> Int) -> WorldChange -> World -> Html AddResource
resourceView emoji getter stagedWorldChange world =
    Html.div []
        [ emoji
            ++ " -> "
            ++ String.fromInt (aggregate world |> getter)
            ++ " ("
            ++ String.fromInt
                (stagedWorldChange
                    |> getter
                )
            ++ ")"
            |> Html.text
        , Html.button
            [ Html.Events.onClick Nature
            ]
            [ text "+"
            ]
        ]


thing : String -> Html msg
thing string =
    Html.div [] [ Html.text string ]


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
