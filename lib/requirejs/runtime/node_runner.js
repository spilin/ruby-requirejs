// Unstubing require https://github.com/sstephenson/execjs/pull/40
(function(program, execjs) { execjs(program) })(function() { #{source}
}, function(program) {
  var output, print = function(string) {
    process.stdout.write('' + string);
  };
  try {
    result = program();
    if (typeof result == 'undefined' && result !== null) {
      print('["ok"]');
    } else {
      try {
        print(json.stringify(['ok', result]));
      } catch (err) {
        print('["err"]');
      }
    }
  } catch (err) {
    print(json.stringify(['err', '' + err]));
  }
});
