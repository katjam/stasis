module World exposing (AddResource(..), World, WorldChange, aggregate, init, resourceAvailable, score, view)

import Html exposing (..)
import Html.Attributes
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
        , resourceView Nature stagedWorldChange world
        , resourceView Crop stagedWorldChange world
        , resourceView City stagedWorldChange world
        ]


type AddResource
    = Nature
    | Crop
    | City


resourceView : AddResource -> WorldChange -> World -> Html AddResource
resourceView resourceMsg stagedWorldChange world =
    Html.div []
        [ emojiFromResource resourceMsg
            ++ " "
            ++ String.fromInt (aggregate world |> getGetter resourceMsg)
            ++ " ("
            ++ String.fromInt
                (stagedWorldChange
                    |> getGetter resourceMsg
                )
            ++ ") "
            ++ laborForResource resourceMsg
            |> Html.text
        , Html.button
            [ Html.Events.onClick resourceMsg
            , Html.Attributes.style "font-size" "40px"
            ]
            [ text "+"
            ]
        ]


resourceAvailable : AddResource -> WorldChange -> World -> Bool
resourceAvailable resource stagedChange world =
    True


laborForResource : AddResource -> String
laborForResource resourceMsg =
    ((case resourceMsg of
        Nature ->
            1

        Crop ->
            2

        City ->
            3
     )
        |> String.fromInt
    )
        ++ " "


getGetter : AddResource -> (WorldChange -> Int)
getGetter addResource =
    case addResource of
        Nature ->
            .nature

        Crop ->
            .crops

        City ->
            .cities


emojiFromResource : AddResource -> String
emojiFromResource resource =
    case resource of
        Nature ->
            "🌳"

        Crop ->
            "🌾"

        City ->
            "🏢"


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
                                ++ " "
                                ++ value
                            )
                        ]
                )
        )
