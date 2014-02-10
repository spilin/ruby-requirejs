(function () {
define('app',[], function () {

  // initialize Application
  var initialize = function () {
  };

  return {
    initialize: initialize
  };
});


require.config({});

require(["app"], function (App) {
  App.initialize();
});

define("application", function(){});
}());