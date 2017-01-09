module App exposing (..)

import Html exposing (Html, text, div, img)
import Http
import Json.Decode exposing (int, string, float, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Debug exposing (..)


getMessages : Cmd Msg
getMessages =
    Http.send MessagesReceived <| (Http.get "http://localhost:3001/messages" decodeMessages)


decodeMessages : Json.Decode.Decoder (List Message)
decodeMessages =
    (Json.Decode.list decodeMessage)


decodeMessage : Decoder Message
decodeMessage =
    decode Message
        |> required "text" string
        |> required "sender_screen_name" string


type alias Model =
    { messages : List Message }


type alias Message =
    { message : String
    , sender_screen_name : String
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( { messages = [] }, getMessages )


type Msg
    = MessagesReceived (Result Http.Error (List Message))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MessagesReceived (Ok result) ->
            ( { model | messages = result }, Cmd.none )

        MessagesReceived (Result.Err err) ->
            (log (toString err))
                ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "hello world" ] ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
