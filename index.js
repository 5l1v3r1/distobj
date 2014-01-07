require('coffee-script');

function mixin(dict, exp) {
  for (var key in dict) {
    if (!dict.hasOwnProperty(key)) continue;
    exp[key] = dict[key];
  }
}

module.exports = {}
module.exports.JSONStream = require('./lib/jsonstream');
mixin(require('./lib/client'), module.exports);
mixin(require('./lib/server'), module.exports);
mixin(require('./lib/emitter'), module.exports);
