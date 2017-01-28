# elm-spotify
A elm application getting the best new albums from pitchfork and finding them in spotify

# Client app
Gets new albums from pitchfork and searches for them on spotify and presents spotify URI

## setup
Install elm
```
elm install
```

## Build

```
  elm-make src/Main.elm --output app.js
  cp index.html app.js albums.css build
```

## Develop
```
  elm reactor
```

## Run
```
  cd srv; node start
```

# Server
a simple koa app scraping the pitchfork site for new albums


```
cd srv
npm install
npm start
```
