require.config({
  paths: {
  "almond": "/assets/almond-598c5f5bd57e4cef3a47fd1eb57b42f0",
  "require": "/assets/require-98f98918193401dc83b22bb7fe50bd4a",
  "app": "/assets/app-e7983d1a4757650fe064cf673ac7d7e6"
}
});

require.config({});

require(["app"], function (App) {
  App.initialize();
});

