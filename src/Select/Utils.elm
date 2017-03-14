module Select.Utils exposing (..)

import Fuzzy
import Html exposing (..)
import Html.Attributes exposing (attribute, class, value)
import Select.Models exposing (..)
import String
import Tuple


referenceDataName : String
referenceDataName =
    "data-select-id"


referenceAttr : Config msg -> ViewArgs msg item -> Attribute msg
referenceAttr config viewArgs =
    attribute referenceDataName viewArgs.id


fuzzyOptions config =
    []
        |> fuzzyAddPenalty config
        |> fuzzyRemovePenalty config
        |> fuzzyMovePenalty config


fuzzyAddPenalty config options =
    case config.fuzzySearchAddPenalty of
        Just penalty ->
            options ++ [ Fuzzy.addPenalty penalty ]

        _ ->
            options


fuzzyRemovePenalty config options =
    case config.fuzzySearchRemovePenalty of
        Just penalty ->
            options ++ [ Fuzzy.removePenalty penalty ]

        _ ->
            options


fuzzyMovePenalty config options =
    case config.fuzzySearchMovePenalty of
        Just penalty ->
            options ++ [ Fuzzy.movePenalty penalty ]

        _ ->
            options


matchedItems : Config msg -> ViewArgs msg item -> List item
matchedItems config viewArgs =
    case viewArgs.query of
        Nothing ->
            viewArgs.items

        Just query ->
            let
                scoreFor =
                    scoreForItem config viewArgs query
            in
                viewArgs.items
                    |> List.map (\item -> ( scoreFor item, item ))
                    |> List.filter (\( score, item ) -> score < config.scoreThreshold)
                    |> List.sortBy Tuple.first
                    |> List.map Tuple.second


scoreForItem : Config msg -> ViewArgs msg item -> String -> item -> Int
scoreForItem config viewArgs query item =
    let
        lowerQuery =
            String.toLower query

        lowerItem =
            viewArgs.toLabel item
                |> String.toLower

        options =
            fuzzyOptions config

        fuzzySeparators =
            config.fuzzySearchSeparators
    in
        Fuzzy.match options fuzzySeparators lowerQuery lowerItem
            |> .score
