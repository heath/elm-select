module Example1 exposing (..)

import Debug
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Movies
import Select


{-| Model to be passed to the select component. You model can be anything.
E.g. Records, tuples or just strings.
-}
type alias Movie =
    { id : String
    , label : String
    }

{-| In your main application model you should store:

  - The selected item e.g. selectedMovieId
  - The state for the select component

-}
type alias Model =
    { focusedField : Maybe InputField
    , id : String
    , movies : List Movie
    , selectedMovieId : Maybe String
    , selectState : Select.State
    }


{-| A field which may be focused
-}
type InputField
    = MovieInput


{-| This just transforms a list of tuples into records
-}
movies : List Movie
movies =
    List.map (\( id, name ) -> Movie id name) Movies.movies


{-| Your model should store the selected item and the state of the Select component(s)
-}
initialModel : String -> Model
initialModel id =
    { focusedField = Nothing
    , id = id
    , movies = movies
    , selectedMovieId = Nothing
    , selectState = Select.newState id
    }


{-| Your application messages need to include:

  - OnSelect item : This will be called when an item is selected
  - SelectMsg (Select.Msg item) : A message that wraps internal Select library messages. This is necessary to route messages back to the component.

-}
type Msg
    = FocusField InputField
    | NoOp
    | OnSelect (Maybe Movie)
    | SelectMsg (Select.Msg Movie)


transformQuery : String -> Maybe String
transformQuery query =
    if String.length query < 4 then
        Nothing
    else
        Just query


{-| Create the configuration for the Select component

`Select.newConfig` takes two args:

  - The selection message e.g. `OnSelect`
  - A function that extract a label from an item e.g. `.label`

-}
selectConfig : Select.Config Msg Movie
selectConfig =
    Select.newConfig OnSelect .label
        |> Select.withCutoff 12
        |> Select.withOnFocus (FocusField MovieInput)
        |> Select.withInputClass "col-12"
        |> Select.withInputStyles [ ( "padding", "0.5rem" ), ( "outline", "none" ) ]
        |> Select.withItemClass "border-bottom border-silver p1 gray"
        |> Select.withItemStyles [ ( "font-size", "1rem" ) ]
        |> Select.withMenuClass "border border-gray"
        |> Select.withMenuStyles [ ( "background", "white" ) ]
        |> Select.withNotFound "No matches"
        |> Select.withNotFoundClass "red"
        |> Select.withNotFoundStyles [ ( "padding", "0 2rem" ) ]
        |> Select.withPrompt "Select a movie"
        |> Select.withPromptClass "grey"
        |> Select.withUnderlineClass "underline"
        |> Select.withTransformQuery transformQuery



--        |> Select.withFuzzySearchMovePenalty 100
--        |> Select.withFuzzySearchSeparators [ " " ]


{-| Your update function should route messages back to the Select component, see `SelectMsg`.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        -- OnSelect is triggered when a selection is made on the Select component.
        OnSelect maybeMovie ->
            let
                maybeId =
                    Maybe.map .id maybeMovie
            in
                ( { model | selectedMovieId = maybeId }, Cmd.none )

        -- Route message to the Select component.
        -- The returned command is important.
        SelectMsg subMsg ->
            let
                ( updated, cmd ) =
                    Select.update selectConfig subMsg model.selectState
            in
                ( { model | selectState = updated }, cmd )

        FocusField field ->
            ( { model | focusedField = Just field } , Cmd.none )

        NoOp ->
            ( model, Cmd.none )


{-| Your view renders the select component passing the config, state, list of items and the currently selected item.
-}
view : Model -> Html Msg
view model =
    let
        selectedMovie =
            case model.selectedMovieId of
                Nothing ->
                    Nothing

                Just id ->
                    List.filter (\movie -> movie.id == id) movies
                        |> List.head
        inputLabel =
            if model.focusedField == Just MovieInput then
                h4
                    [ style [ ("color", "green") ] ]
                    [ text "Pick a movie" ]
            else
                h4 [] [ text "Pick a movie" ]
    in
        div [ class "bg-silver p1" ]
            [ h3 [] [ text "Basic example" ]
            , text (toString model.selectedMovieId)

            -- Render the Select view. You must pass:
            -- - The configuration
            -- - A unique identifier for the select component
            -- - The Select internal state
            -- - A list of items
            -- - The currently selected item as Maybe
            , inputLabel
            , Html.map SelectMsg (Select.view selectConfig model.selectState model.movies selectedMovie)
            ]
