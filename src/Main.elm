module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)
import World



-- MAIN


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = viewDocument
        }


type alias Model =
    ()


init : () -> ( Model, Cmd Msg )
init _ =
    ( (), Cmd.none )


type alias Msg =
    ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( (), Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = "Some cats", body = [ view model ] }


view : Model -> Html Msg
view model =
    World.init |> World.view
