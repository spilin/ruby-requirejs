# Ruby Requirejs
[![Gem Version](https://badge.fury.io/rb/ruby-requirejs.png)](http://badge.fury.io/rb/ruby-requirejs)
[![Code Climate](https://codeclimate.com/github/spilin/ruby-requirejs.png)](https://codeclimate.com/github/spilin/ruby-requirejs)
[![Build Status](https://travis-ci.org/spilin/ruby-requirejs.png?branch=master)](https://travis-ci.org/spilin/ruby-requirejs)

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-requirejs'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-requirejs


## Configuration

### With Rails and the Asset Pipeline.

#### Development
You have several options. For development default configuration should be enough for you.
By default requirejs will not perform any optimization or compression.

#### Production
For production setup you would probably want to use [almond](https://github.com/jrburke/almond) as an alternative loader.
To enable `almond` you need to configure your `config/environments/{environment}.rb` or `config/environment.rb` if you want to use `almond` all the time (I would not recommend it)

    config.requirejs.loader = :almond

`ruby-requirejs` currently supports js_compression only with `uglifier`. To enable:

    config.requirejs.js_compressor = :uglifier

If you don't want to use `almond` remove `config.requirejs.loader = :almond` and instead add `config.requirejs.optimize = true`

### Standalone Sprockets usage

#### TODO: Coming soon

## Usage

In your `application.js` add directive `rjs` so `ruby-requirejs` will know that this file should be processed as an entry point
Example of `application.js` can look like this:

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

    require(["jquery", "turbolinks", "jquery_ujs", "app"], function ($, Turbolinks, uJS, App) {
      App.initialize();
    });

During `r.js` optimization `ruby-requirejs` will automatically add fingerprints to assets if this is set in configuration.

## Contributing

Want to add some examples? Document code? Implement new feature? Fix bug?

1. Fork it ( http://github.com/spilin/ruby-requirejs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
