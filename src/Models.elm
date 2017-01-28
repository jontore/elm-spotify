module Models exposing (..)

import Html.Events exposing (..)
import Json.Decode exposing (..)
import Debug exposing (..)

import Http

type Msg
  = Refresh
  | NewBestAlbums (Result Http.Error (List Review))
  | NewSpotifySearch (Result Http.Error (List SpotifyResult))

type alias Model =
  {
      reviews: List Review
    , albums: List SpotifyResult
  }

type alias Review =
  { url : String
  , artist : String
  , image : String
  , album : String
  }

type alias SpotifyResult =
  { uri: String,
    artist: String,
    album: String,
    image: String,
    open: String
  }

init : String -> (Model, Cmd Msg)
init topic =
  ( Model [] []
  , getBestAlbums
  )

-- HTTP


getBestAlbums: Cmd Msg
getBestAlbums =
  let
    url =
      "./best_albums/"
  in
    Http.send NewBestAlbums (Http.get url decodeReviews)


getSpotifyAlbums: (List Review) -> Cmd Msg
getSpotifyAlbums reviews =
  Cmd.batch (List.map getSpotifyAlbum reviews)

getSpotifyAlbum: Review -> Cmd Msg
getSpotifyAlbum review =
    let
      url = ("https://api.spotify.com/v1/search?type=album&q=album:" ++ Http.encodeUri(review.album) ++ "%20artist:" ++ Http.encodeUri(review.artist))
    in
        Http.send NewSpotifySearch (Http.get url decodeSpotifySearch)

decodeReviews : Decoder (List Review)
decodeReviews =
  Json.Decode.list artistDecoder

artistDecoder : Decoder Review
artistDecoder =
  map4 Review
    (at ["url"] string)
    (at ["artist"] string)
    (at ["image"] string)
    (at ["album"] string)

decodeSpotifySearch: Decoder (List SpotifyResult)
decodeSpotifySearch =
    at ["albums", "items"] (Json.Decode.list decodeSpotifyAlbum)

decodeSpotifyAlbum: Decoder SpotifyResult
decodeSpotifyAlbum =
  map5 SpotifyResult
    (at ["uri"] string)
    (at ["artists"] (index 0 (at ["name"] string)))
    (at ["name"] string)
    (at ["images"] (index 0 (at ["url"] string)))
    (at ["uri"] string)
