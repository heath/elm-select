module Select.Update exposing (..)

import Select.Models as Models
import Select.Messages exposing (..)
import Task


update : Models.Config msg item -> Msg item -> Models.State -> ( Models.State, Cmd msg )
update config msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        OnEsc ->
            ( { model | query = Nothing }, Cmd.none )

        OnInputBlur ->
            ( { model | query = Nothing }, Cmd.none )

        OnQueryChange value ->
            ( { model | query = Just value }, Cmd.none )

        OnSelect item ->
            let
                cmd =
                    Task.succeed item
                        |> Task.perform config.onSelect
            in
                ( { model | query = Nothing }, cmd )
