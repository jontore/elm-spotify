module Main exposing (..)

import Html exposing (..)

import Models exposing (..)
import Views exposing (..)
import Routing exposing (..)

import Navigation exposing (Location)
import String
import Debug

main =
  Navigation.program OnLocationChange
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- Init

init : Location -> ( Model, Cmd Msg )
init location =
    let
        (currentRoute, token) =
            Routing.parseLocation location
    in
        ( (initialModel currentRoute token), (getCommandForRoute currentRoute token) )


-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
   Refresh ->
     (model, authenticate)
   OnLocationChange (location) ->
     let
       (newRoute, newToken) = parseLocation location
       cmd = getCommandForRoute newRoute newToken
     in
       ( { model | route = newRoute, token = (Debug.log "token" newToken) }, Cmd.none )
   Authenticate ->
     (model, authenticate)
   NewBestAlbums (Ok newReviews) ->
     ({ model | route = ListRoute, reviews = newReviews }, getSpotifyAlbums newReviews model.token)
   NewBestAlbums (Err _) ->
     (model, Cmd.none)
   NewSpotifySearch (Ok r) ->
     ({ model | albums=(List.concat [model.albums, r]) }, Cmd.none)
   NewSpotifySearch (Err e) ->
     (model, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
