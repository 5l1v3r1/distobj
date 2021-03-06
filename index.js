require('coffee-script');

function mixin(dict, exp) {
  for (var key in dict) {
    if (!dict.hasOwnProperty(key)) continue;
    exp[key] = dict[key];
  }
}

module.exports = {}
module.exports.JSONStream = require('./lib/jsonstream');
module.exports.Client = require('./lib/client');
module.exports.Server = require('./lib/server');
mixin(require('./lib/emitter'), module.exports);
