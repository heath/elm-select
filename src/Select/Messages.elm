module Select.Messages exposing (..)


type Msg item
    = NoOp
    | OnBlur
    | OnClear
    | OnEsc
    | OnFocus
    | OnQueryChange String
    | OnSelect item
