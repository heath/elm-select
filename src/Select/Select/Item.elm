module Select.Select.Item exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, style, tabindex)
import Html.Events exposing (onClick, on, keyCode)
import Json.Decode as Decode


--import Select.Events exposing (onBlurAttribute)

import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Utils exposing (referenceAttr)


onKeyUpAttribute : item -> Attribute msg
onKeyUpAttribute item =
    let
        fn code =
            case code of
                13 ->
                    Decode.succeed (OnSelect item)

                32 ->
                    Decode.succeed (OnSelect item)

                27 ->
                    Decode.succeed OnEsc

                _ ->
                    Decode.fail "not ENTER"
    in
        on "keyup" (Decode.andThen fn keyCode)


view : Config msg -> ViewArgs msg item -> item -> Html msg
view config viewArgs item =
    let
        baseAttrs_ =
            baseAttrs config
                ++ [ style
                        [ ( "cursor", "pointer" )
                        ]
                   , onClick (OnSelect item)
                     --, onBlurAttribute config state
                   , onKeyUpAttribute item
                   , referenceAttr config viewArgs
                   , tabindex 0
                   ]
    in
        div baseAttrs_
            [ text (viewArgs.toLabel item)
            ]


viewNotFound : Config msg -> Html msg
viewNotFound config =
    let
        baseAttrs_ =
            baseAttrs config ++ config.notFoundAttrs
    in
        if config.notFound == "" then
            text ""
        else
            div baseAttrs_
                [ text config.notFound ]


baseAttrs : Config msg -> String
baseAttrs config =
    [ class "elm-select-item"
    ]
        ++ config.itemAttrs
