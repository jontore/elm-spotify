module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)


renderAlbum: SpotifyResult -> Html Msg
renderAlbum album = li [] [
    h3 [] [
      text "Review: "
      , text album.artist
    ]
    , p [ class "Album" ] [
        text " "
        , img [src album.image] []
        , text album.album
        , text " uri: "
        , text album.open
    ]
  ]

view : Model -> Html Msg
view model =
  div [] [
    h2 [] [text "Best albums"]
    , br [] []
    , ul [] (List.map renderAlbum model.albums)
  ]
