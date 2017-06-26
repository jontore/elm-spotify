module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)


renderAlbum: SpotifyResult -> Html Msg
renderAlbum album = li [ class "album" ] [
    h3 [class "album-title"] [
      text album.artist
    ]
    , img [class "album-img", src album.image] []
    , p [] [
        text " "
        , text album.album
    ]
    , p [] [
        a [ href album.open, class "album-open"] [ text "Open"]
    ]
  ]

view: Model -> Html Msg
view model =
  div [] [
    header model
    , br [] []
    , page model
  ]

header: Model -> Html Msg
header model =
    h1 [ class "title"] [
      text "Best new albums from "
      , a [href "http://pitchfork.com/reviews/best/albums/"] [ text "Pitchfork" ]
    ]

page: Model -> Html Msg
page model =
    let
      route = model.route
      token = model.token
    in
      if String.isEmpty(token) then
          loginPage model
      else
          case model.route of
              ListRoute -> albumsPage model
              NotFoundRoute -> text "Not Found"
              _ -> loadigPage model


albumsPage: Model -> Html Msg
albumsPage model =
    ul [ class "albums" ] (List.map renderAlbum model.albums)


loadigPage: Model -> Html Msg
loadigPage model =
  div [ class "center-container" ] [
    text "loading...."
  ]


loginPage: Model -> Html Msg
loginPage model =
  div [ class "center-container" ] [
    button [ class "login-button", onClick Authenticate ] [ text "Login and search" ]
  ]
