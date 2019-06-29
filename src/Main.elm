module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)
import World exposing (WorldChange)


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
    { stagedWorldChange : WorldChange
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { stagedWorldChange =
            { cities = 0
            , crops = 0
            , nature = 0
            }
      }
    , Cmd.none
    )


type alias Msg =
    ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = "Stasis", body = [ view model ] }


view : Model -> Html Msg
view model =
    [ World.init ] |> World.view
