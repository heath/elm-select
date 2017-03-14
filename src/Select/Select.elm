module Select.Select exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, id, style)
import Select.Messages exposing (..)
import Select.Models exposing (..)
import Select.Select.Menu
import Select.Select.Input


view : Config -> ViewArgs msg item -> Html msg
view config viewArgs =
    let
        classes =
            "elm-select"

        styles =
            [ ( "position", "relative" ) ]
    in
        div [ id viewArgs.id, class classes, style styles ]
            [ Select.Select.Input.view config viewArgs
            , Select.Select.Menu.view config viewArgs
            ]
