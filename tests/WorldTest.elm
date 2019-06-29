module WorldTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "World"
        [ test "prints empty grid" <|
            \() ->
                2
                    |> Expect.equal 2
        ]
