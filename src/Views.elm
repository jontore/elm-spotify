module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)


renderAlbum: SpotifyResult -> Html Msg
renderAlbum album = li [ class "album" ] [
    h3 [class "album-title"] [
      text "Review: "
      , text album.artist
    ]
    , img [class "album-img", src album.image] []
    , p [] [
        text " "
        , text album.album
    ]
    , p [] [
        text " uri: "
        , text album.open
    ]
  ]

view : Model -> Html Msg
view model =
  div [] [
    h1 [ class "title"] [
      text "Best new albums from "
      , a [href "http://pitchfork.com/reviews/best/albums/"] [ text "Pitchfork" ]
    ]
    , br [] []
    , ul [ class "albums" ] (List.map renderAlbum model.albums)
  ]
