module WorldTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import World


suite : Test
suite =
    describe "World"
        [ test "prints empty grid" <|
            \() ->
                World.init
                    |> Expect.equal
                        { nature = 0
                        , crops = 0
                        , cities = 0
                        }
        , test "initial score" <|
            \() ->
                World.init
                    |> World.score
                    |> Expect.equal
                        { cropYield = 2
                        , productivity = 2
                        , co2Offset = 0
                        }
        ]
