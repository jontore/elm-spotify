module Models exposing (..)

import Html.Events exposing (..)
import Json.Decode exposing (..)
import Debug exposing (..)

import Http
import Navigation


type Msg
  = Refresh
  | Authenticate
  | OnLocationChange Navigation.Location
  | NewBestAlbums (Result Http.Error (List Review))
  | NewSpotifySearch (Result Http.Error (List SpotifyResult))

type Route
    = ListRoute
    | AuthenticateRoute
    | NotFoundRoute
    | RootRoute

type alias Model =
  {
      reviews: List Review
    , albums: List SpotifyResult
    , route: Route
    , token: Token
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

type alias Token = String

initialModel : Route -> Token -> Model
initialModel route token = Model [] [] route token

clientId : String
clientId = "e777ac1ca10f4f7e9786f73bf4d0267c"

redirectUri : String
-- redirectUri = "http://forkify.apps.internetandipa.com/callback/"
redirectUri = "http://localhost:8000/callback/"

-- HTTP

authenticate: Cmd Msg
authenticate =
  let
    url = ("https://accounts.spotify.com/authorize?client_id=" ++ clientId ++ "&redirect_uri=" ++ Http.encodeUri(redirectUri) ++ "&scope=user-read-private%20user-read-email&response_type=token&state=123")
  in
      Navigation.load url

getBestAlbums: Cmd Msg
getBestAlbums =
  let
    url =
      "http://localhost:3000/best_albums/"
  in
    Http.send NewBestAlbums (Http.get url decodeReviews)


getSpotifyAlbums: (List Review) -> Token -> Cmd Msg
getSpotifyAlbums reviews token =
  Cmd.batch (List.map (\a -> getSpotifyAlbum a token) reviews)

getSpotifyAlbum: Review -> Token -> Cmd Msg
getSpotifyAlbum review token =
    let
      url = ("https://api.spotify.com/v1/search?type=album&q=album:" ++ Http.encodeUri(review.album) ++ "%20artist:" ++ Http.encodeUri(review.artist))
    in
        Http.send NewSpotifySearch (getSpotify url token decodeSpotifySearch)

getSpotify : String -> Token -> Decoder (List SpotifyResult) ->  Http.Request (List SpotifyResult)
getSpotify url token decoder =
    Http.request
        { method = "GET"
        , headers = [Http.header "Authorization" ("Bearer " ++ token)]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }

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
    (at ["external_urls", "spotify"] string)
