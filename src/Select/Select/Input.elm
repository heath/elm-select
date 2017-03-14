module Select.Select.Input exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, placeholder, value, style)
import Html.Events exposing (on, onInput, onWithOptions)
import Json.Decode as Decode
import Select.Events exposing (onEsc)
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Select.Clear as Clear
import Select.Utils exposing (referenceAttr)


inputWrapperAttrs config =
    [ class "elm-select-input-wrapper"
    , style [ ( "position", "relative" ) ]
    ]
        ++ config.inputWrapperAttrs


inputAttrs config viewArgs =
    let
        currentValue =
            case viewArgs.query of
                Nothing ->
                    case viewArgs.selected of
                        Nothing ->
                            ""

                        Just item ->
                            config.toLabel item

                Just str ->
                    str

        baseAttrs =
            [ class "elm-select-input"
            , style [ ( "width", "100%" ) ]
              --, onBlurAttribute config model
            , onEsc OnEsc
            , onInput OnQueryChange
            , placeholder config.prompt
            , referenceAttr config viewArgs
            , value currentValue
            ]

        promptAttrs =
            case viewArgs.selected of
                Nothing ->
                    config.promptAttrs

                Just _ ->
                    []
    in
        baseAttrs
            ++ config.inputAttrs
            ++ promptAttrs


clearAttrs config viewArgs =
    let
        onClickWithoutPropagation msg =
            Decode.succeed msg
                |> onWithOptions "click" { stopPropagation = True, preventDefault = False }

        baseStyles =
            [ ( "cursor", "pointer" )
            , ( "height", "1rem" )
            , ( "line-height", "0rem" )
            , ( "margin-top", "-0.5rem" )
            , ( "position", "absolute" )
            , ( "right", "0.25rem" )
            , ( "top", "50%" )
            ]

        baseAttrs =
            [ class "elm-select-clear"
            , style baseStyles
            , onClickWithoutPropagation OnClear
            ]
    in
        baseAttrs ++ config.clearAttrs


clearView config viewArgs =
    case viewArgs.selected of
        Nothing ->
            text ""

        Just _ ->
            div (clearAttrs config viewArgs) [ Clear.view config ]


view : Config msg -> ViewArgs msg item -> Html msg
view config viewArgs =
    let
        inputWrapperAttrs_ =
            inputWrapperAttrs config

        inputAttrs_ =
            inputAttrs config viewArgs
    in
        div inputWrapperAttrs_
            [ input inputAttrs_ []
            , clearView config viewArgs
            ]
