module Routing exposing (..)

import Array
import Navigation exposing (Location)
import Models exposing (..)
import UrlParser exposing (..)
import Regex exposing (..)
import String

matchersPath : Parser (Route -> a) a
matchersPath =
    oneOf
        [ map RootRoute top
        , map ListRoute (s "albums")
        , map AuthenticateRoute (s "callback")
        ]

parseToken: Navigation.Location -> Token
parseToken location =
    let
      matches = (find (AtMost 1) (regex ".+?#access_token=(.+?)&.+") location.href)
      possibleTokenMatch = List.head matches
    in
      case possibleTokenMatch of
        Just headMatch ->
          case (List.head headMatch.submatches) of
            Just possibleSubMatch ->
              case possibleSubMatch of
                Just submatch -> submatch
                Nothing -> ""
            Nothing -> ""
        Nothing -> ""

parseLocation: Navigation.Location -> (Route, Token)
parseLocation location =
    let
      token = parseToken location
    in
      case (UrlParser.parsePath matchersPath location) of
          Just route ->
              (route, token)
          Nothing ->
              (NotFoundRoute, token)

getCommandForRoute: Route -> Token -> Cmd Msg
getCommandForRoute route token =
  case route of
    NotFoundRoute ->
        Cmd.none
    _ ->
      if String.isEmpty(token) then Cmd.none else getBestAlbums
