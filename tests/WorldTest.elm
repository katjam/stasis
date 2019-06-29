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
                        [ { nature = 0
                          , crops = 1
                          , cities = 1
                          }
                        ]
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
        , test "aggregate score" <|
            \() ->
                [ { cities = 1
                  , crops = 2
                  , nature = 3
                  }
                , { cities = 4
                  , crops = 5
                  , nature = 6
                  }
                ]
                    |> World.aggregate
                    |> Expect.equal
                        { cities = 5
                        , crops = 7
                        , nature = 9
                        }
        , test "resourceAvailable want to build nothing" <|
            \() ->
                World.resourceAvailable World.Nature
                    { cities = 0
                    , crops = 0
                    , nature = 0
                    }
                    [ { cities = 1
                      , crops = 0
                      , nature = 3
                      }
                    ]
                    |> Expect.equal True
        , test "resourceAvailable with non-zero values" <|
            \() ->
                World.resourceAvailable World.Nature
                    { cities = 1
                    , crops = 0
                    , nature = 0
                    }
                    [ { cities = 1
                      , crops = 0
                      , nature = 3
                      }
                    ]
                    |> Expect.equal False
        ]
