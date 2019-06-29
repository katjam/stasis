module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)
import World exposing (World, WorldChange)


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
    , world : World
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { stagedWorldChange =
            { cities = 0
            , crops = 0
            , nature = 0
            }
      , world =
            World.init
      }
    , Cmd.none
    )


type Msg
    = ChangeTheWorld
    | StageResource World.AddResource


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTheWorld ->
            ( stageWorldChange model
            , Cmd.none
            )

        StageResource newResource ->
            let
                stagedResource =
                    model.stagedWorldChange
            in
            case newResource of
                World.Nature ->
                    ( { model
                        | stagedWorldChange =
                            { stagedResource | nature = stagedResource.nature + 1 }
                      }
                    , Cmd.none
                    )

                World.Crop ->
                    ( { model
                        | stagedWorldChange =
                            { stagedResource | crops = stagedResource.crops + 1 }
                      }
                    , Cmd.none
                    )

                World.City ->
                    ( { model
                        | stagedWorldChange =
                            { stagedResource | cities = stagedResource.cities + 1 }
                      }
                    , Cmd.none
                    )


stageWorldChange : Model -> Model
stageWorldChange model =
    { model
        | stagedWorldChange =
            { cities = 0
            , crops = 0
            , nature = 0
            }
        , world =
            model.world ++ [ model.stagedWorldChange ]
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = "Stasis", body = [ view model ] }


view : Model -> Html Msg
view model =
    div []
        [ model.world
            |> World.view model.stagedWorldChange
            |> Html.map StageResource
        , Html.button
            [ Html.Events.onClick ChangeTheWorld ]
            [ text "Change the World! 🌏 🙌" ]
        ]
