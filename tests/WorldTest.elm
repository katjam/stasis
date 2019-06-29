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
                        [ [ Nothing, Nothing, Nothing ]
                        , [ Nothing, Nothing, Nothing ]
                        , [ Nothing, Nothing, Nothing ]
                        ]
        ]
