'use strict';
let getBestNewAlbums = require('./pitchfork').default;
let logger = require('koa-logger');
let route = require('koa-route');
let cors = require('koa-cors');
let serve = require('koa-static');
let koa = require('koa');
let app = module.exports = koa();

// Logger
app.use(logger());
app.use(cors());
app.use(serve('build'));

console.log(getBestNewAlbums);
app.use(route.get('/best_albums/', getBestNewAlbums));

if (!module.parent) {
  app.listen(1337);
  console.log('listening on port 1337');
}
