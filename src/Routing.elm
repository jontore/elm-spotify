module Routing exposing (..)

import Array
import Dict
import Navigation exposing (Location)
import Navigation.Router as Router
import Navigation.Builder as Builder
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

getCommandForRoute: Location -> Route -> Token -> Cmd Msg
getCommandForRoute location route token =
  let
    model = Router.init location
    (_, urlChangeCmd) = Router.urlChanged model resetQuery
  in
    case route of
      NotFoundRoute ->
          Cmd.none
      _ ->
        if String.isEmpty(token) then Cmd.none else Cmd.batch [getBestAlbums, urlChangeCmd]


resetQuery : Maybe Router.UrlChange
resetQuery =
    let
        pathBuilder = Builder.builder
            |> Builder.replaceQuery (Dict.empty)
    in
        Just <| Builder.toUrlChange pathBuilder
