module WorldTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import World


suite : Test
suite =
    describe "World"
        [ test "initial state" <|
            \() ->
                World.init
                    |> Expect.equal
                        { nature = 0
                        , crops = 0
                        , cities = 0
                        }
        , test "all zero" <|
            \() ->
                [ { cities = 0
                  , crops = 0
                  , nature = 0
                  }
                ]
                    |> World.score
                    |> Expect.equal
                        { cropYield = 0
                        , cropUse = 0
                        , productivity = 0
                        , co2Offset = 0
                        }
        , test "other data" <|
            \() ->
                [ { cities = 1
                  , crops = 1
                  , nature = 1
                  }
                ]
                    |> World.score
                    |> Expect.equal
                        { cropYield = 1
                        , cropUse = 1
                        , productivity = 3
                        , co2Offset = 0
                        }
        , test "combine multiple scores" <|
            \() ->
                [ { cities = 1
                  , crops = 1
                  , nature = 1
                  }
                , { cities = 0
                  , crops = 0
                  , nature = 3
                  }
                ]
                    |> World.score
                    |> Expect.equal
                        { cropYield = 1
                        , cropUse = 1
                        , productivity = 3
                        , co2Offset = 6
                        }
        ]
