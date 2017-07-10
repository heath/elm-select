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

        OnBlur ->
            ( { model
                  | query = Nothing
                  , focus = False
              }
            , Cmd.none
            )

        OnClear ->
            let
                cmd =
                    Task.succeed Nothing
                        |> Task.perform config.onSelect
            in
                ( { model | query = Nothing }, cmd )

        OnFocus ->
            let
                cmd =
                    case config.onFocus of
                        Nothing ->
                            Cmd.none

                        Just msg ->
                            Task.succeed Nothing
                                |> Task.perform (\x -> msg)

            in
                ( { model | focus = True }, cmd )

        OnQueryChange value ->
            let
                cmd =
                    case config.onQueryChange of
                        Nothing ->
                            Cmd.none

                        Just constructor ->
                            Task.succeed value
                                |> Task.perform constructor
            in
                ( { model | query = Just value }, cmd )

        OnSelect item ->
            let
                cmd =
                    Task.succeed (Just item)
                        |> Task.perform config.onSelect
            in
                ( { model | query = Nothing }, cmd )
