import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)
import Debug exposing (..)

import Http


main =
  Html.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL

type alias Model =
  {
    reviews: List Review
  }

type alias Review =
  { url : String
  , artist : String
  , album : String
  }

init : String -> (Model, Cmd Msg)
init topic =
  ( Model []
  , getBestAlbums
  )


-- UPDATE


type Msg
  = Refresh
  | NewBestAlbums (Result Http.Error (List Review))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
   Refresh ->
     (model, getBestAlbums)
   NewBestAlbums (Ok m) ->
     (Model m, Cmd.none)

   NewBestAlbums (Err _) ->
     (model, Cmd.none)




-- VIEW
renderReview: Review -> Html Msg
renderReview review = li [] [
    text "Review: "
  , text review.artist
  , text " "
  , text review.album
  ]

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text "Best abbums"]
    , button [ onClick Refresh ] [ text "Get reviews!" ]
    , br [] []
    , ul [] (List.map renderReview model.reviews)
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- HTTP


getBestAlbums: Cmd Msg
getBestAlbums =
  let
    url =
      "http://localhost:1337/best_albums/"
  in
    Http.send NewBestAlbums (Http.get url decodeReviews)

decodeReviews : Decoder (List Review)
decodeReviews =
  Json.Decode.list artistDecoder

artistDecoder : Decoder Review
artistDecoder =
  map3 Review
    (at ["artist"] string)
    (at ["url"] string)
    (at ["album"] string)
