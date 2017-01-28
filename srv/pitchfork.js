var request = require('superagent');
var cheerio = require('cheerio');
var thunkify = require('thunkify');

request.get = thunkify(request.get);

// global constants
var VERSION = require('../package').version
, USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36'
, BASE_URL = "http://pitchfork.com/reviews/best/albums/"
, CONNECTION_ERR = new Error("Failed to connect to Pitchfork!");

getBestNewAlbums = function * (next) {
  var res = yield request.get(BASE_URL);
  if ((res && res.statusCode != 200)) {
    yield(next);;
  } else {
    var $ = cheerio.load(res.text);
    var reviewEls = $('.review');

    var reviewObjs = reviewEls.map(function(i, reviewEl) {
      var reviewEl$ = $(reviewEl);
      return {
        url: reviewEl$.find('.album-link').attr('href'),
        image: reviewEl$.find('.album-link img').attr('src'),
        artist: reviewEl$.find('.album-artist .artist-list').text(),
        album: reviewEl$.find('.review .album-artist .title').text()
      }
    }).get();
    this.body = reviewObjs;
  }
};

exports.default = getBestNewAlbums;
