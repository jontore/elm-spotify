import Json.Decode exposing (..)

type alias Model =
  { url : String
  , artist : String
  , album : String
  }

makeModel : String -> String -> String -> Model
makeModel url artist album = { url = url, artist = artist, album = album }

artiestDecoder : Decoder Model
artiestDecoder =
  object3 makeModel
    ("artist" := string)
    ("url" := string)
    ("album" := string)
