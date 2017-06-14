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

app.use(route.get('/best_albums/', getBestNewAlbums));
app.use(route.get('/*', function * (next) {

}));

if (!module.parent) {
  app.listen(process.env.PORT || 3000);
  console.log('listening on port 3000');
}
