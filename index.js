require('coffee-script');

function mixin(dict, exp) {
  for (var key in dict) {
    if (!dict.hasOwnProperty(key)) continue;
    exp[key] = dict[key];
  }
}

mixin(require('./lib/jsonstream'), module.exports);
