'use strict';
var getBestNewAlbums = require('./pitchfork').default;
var logger = require('koa-logger');
var route = require('koa-route');
var cors = require('koa-cors');
var koa = require('koa');
var app = module.exports = koa();

// Logger
app.use(logger());
app.use(cors());

console.log(getBestNewAlbums);
app.use(route.get('/best_albums/', getBestNewAlbums));

if (!module.parent) {
  app.listen(1337);
  console.log('listening on port 1337');
}
