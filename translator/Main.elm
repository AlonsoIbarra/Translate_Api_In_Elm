import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (Decoder)
import Json.Encode as Encode
import Http
import Auth


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , update = update
        , init = init
        , subscriptions = always Sub.none
        }

type alias Model =
    { text : String
    , langList : List (String, String)
    , lang : String
    , translate : List String
    , error : String
    }

type Msg =
    InputText String
    | ChangeLang String
    | ResponseAPI (Result Http.Error (List String) )

init : (Model, Cmd Msg )
init = 
    ( { text = ""
    , langList = 
        [ ("Español", "es")
        , ("English", "en")
        , ("Russian", "ru")
        , ( "Latin", "la")
        ]
    , lang = "es"
    , translate = [ ]
    , error = ""
    }
    , Cmd.none
    )

update : Msg -> Model -> ( Model, Cmd Msg ) 
update msg model =
    case msg of
        ResponseAPI response ->
            case response of
                Ok dataResponse ->
                    ( { model | translate = dataResponse } , Cmd.none )
                Err error ->
                    ( { model | error = Debug.log "Error : " (toString error) }, Cmd.none)
        InputText  text ->
            ({ model | text = text }, updateText { model | text = text } )
        ChangeLang lang->
            ( { model | lang = lang } , updateText { model | lang = lang } )

updateText : Model -> Cmd Msg
updateText model =
    Http.send ResponseAPI (sendRequestAPI model )  

sendRequestAPI : Model -> Http.Request (List String)
sendRequestAPI model =
    Http.request
        { method = "GET"
        , expect =  Http.expectJson dataTranslateDecoder
        , headers = [ ]
        , url = Debug.log "URLRequest: " (getUrlAPI model)
        , body = Http.emptyBody
        , withCredentials = False
        , timeout = Nothing
        } 

getUrlAPI : Model -> String -- construye la url del api
getUrlAPI model = 
    Auth.url_api 
    ++ "?key=" ++ Auth.app_key
    ++ "&lang=" ++ model.lang
    ++ "&text=" ++ model.text

dataTranslateDecoder : Decoder (List String)
dataTranslateDecoder =
    Json.Decode.at [ "text" ] (Json.Decode.list Json.Decode.string)

view : Model -> Html Msg
view model =
    div [ class "content"]
        [ Html.header []
            [ div [ class "head" ] 
                [ h1 [] [ text "Traductor en Elm" ] 
                ] 
            ]
        , div [ class "content-body" ]
            [ div [ class "input-form" ]
                [ h1 [ ] [ text "Texto"]
                , div [ class "row" ] 
                    [ textarea [ class "text", onInput InputText, placeholder "texto..." ] []
                    ]
                ]
            , div [ class "input-form" ]
                [   h1 [ ] [ text "Traducción" ]
                , div [class "row" ]
                    [ viewLanguajes model.langList ] 
                , div [ class "row" ] [ text (toString ( model.translate ) ) ]
                , div [ class "row" ] []
                ]
            ]
        ]

viewLanguajes : List (String, String) -> Html Msg
viewLanguajes listLanguajes =
  fieldset [] (List.map radio listLanguajes)

radio : (String, String) -> Html Msg
radio (lenguaje, abr) =
  label []
    [ input [ type_ "radio", name "lang", checked True, onClick ( ChangeLang abr ) ] []
    , text lenguaje
    ]