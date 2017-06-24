'use strict';
let getBestNewAlbums = require('./pitchfork').default;
let logger = require('koa-logger');
let route = require('koa-route');
let cors = require('koa-cors');
let serve = require('koa-static');
let kSend = require('koa-send');
let koa = require('koa');
let app = module.exports = koa();

// Logger
app.use(logger());
app.use(cors());
app.use(serve('build'));

app.use(route.get('/best_albums/', getBestNewAlbums));
app.use(function* index() {
  yield kSend(this, 'build/index.html');
});

if (!module.parent) {
  app.listen(process.env.PORT || 8000);
  console.log('listening on port 8000');
}
