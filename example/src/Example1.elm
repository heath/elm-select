module Example1 exposing (..)

import Html exposing (..)
import Select


view : Html msg
view =
    div []
        [ div [] [ text "Example 1" ]
        , Select.view
        ]
