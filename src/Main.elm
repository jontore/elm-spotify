module Main exposing (..)

import Html exposing (..)

import Models exposing (..)
import Views exposing (..)

main =
  Html.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
   Refresh ->
     (model, getBestAlbums)
   NewBestAlbums (Ok reviews) ->
     (Model reviews [], getSpotifyAlbums reviews)

   NewBestAlbums (Err _) ->
     (model, Cmd.none)

   NewSpotifySearch (Ok r) ->
     (Model model.reviews (List.concat [model.albums, r]), Cmd.none)

   NewSpotifySearch (Err e) ->
     (model, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
