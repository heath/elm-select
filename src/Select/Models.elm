module Select.Models exposing (..)

import Html


type alias Style =
    ( String, String )


type alias Config msg =
    { clearAttrs : List (Html.Attribute msg)
    , clearSvgAttrs : List (Html.Attribute msg)
    , cutoff : Maybe Int
    , fuzzySearchAddPenalty : Maybe Int
    , fuzzySearchMovePenalty : Maybe Int
    , fuzzySearchRemovePenalty : Maybe Int
    , fuzzySearchSeparators : List String
    , inputAttrs : List (Html.Attribute msg)
    , inputWrapperAttrs : List (Html.Attribute msg)
    , itemAttrs : List (Html.Attribute msg)
    , menuAttrs : List (Html.Attribute msg)
    , notFound : String
    , notFoundAttrs : List (Html.Attribute msg)
    , prompt : String
    , promptAttrs : List (Html.Attribute msg)
    , scoreThreshold : Int
    }


type alias ViewArgs msg item =
    { id : String
    , items : List item
    , onSelect : Maybe item -> msg
    , query : Maybe String
    , selected : Maybe item
    , toLabel : item -> String
    }


newConfig : Config msg
newConfig =
    { clearAttrs = []
    , clearSvgAttrs = []
    , cutoff = Nothing
    , fuzzySearchAddPenalty = Nothing
    , fuzzySearchMovePenalty = Nothing
    , fuzzySearchRemovePenalty = Nothing
    , fuzzySearchSeparators = []
    , inputAttrs = []
    , inputWrapperAttrs = []
    , itemAttrs = []
    , menuAttrs = []
    , notFound = "No results found"
    , notFoundAttrs = []
    , prompt = ""
    , promptAttrs = []
    , scoreThreshold = 500
    }


type alias State =
    { id : String
    , query : Maybe String
    }


newState : String -> State
newState id =
    { id = id
    , query = Nothing
    }
