//= rjs

require.config({
  shim:{
    "jquery":{
      exports:"$"
    },
    "turbolinks":{
      exports:"Turbolinks"
    },
    "jquery_ujs":["jquery"],
    "app":{
      deps:[
        "jquery",
        "jquery_ujs",
        "turbolinks"
      ]
    }
  },

	waitSeconds: 10,
  catchError:false
});

require.onError = function (err) {
  if (err.requireType === 'timeout') {
    console.log("RequireJS: timeout");
  } else {
    console.log("RequireJS: error " + err.message);
  }
};

require(["jquery", "turbolinks", "jquery_ujs", "app"], function ($, Turbolinks, uJS, App) {
  App.initialize();
});