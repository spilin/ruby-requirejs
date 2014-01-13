module Requirejs
  module Rails
    class Railtie < ::Rails::Railtie

      config.before_configuration do
        config.requirejs = Requirejs.config = Requirejs::Config.new
        Requirejs.config.cache_location = ::Rails.root.join('tmp', 'ruby-requirejs')
        #config.requirejs.precompile = [/require\.js$/]
      end

      config.assets.configure do |env|
        require 'requirejs/tilt/template'
        require 'requirejs/tilt/directive_processor'
        env.unregister_processor('application/javascript', Sprockets::DirectiveProcessor)
        env.register_preprocessor('application/javascript', Requirejs::Tilt::DirectiveProcessor)
        env.register_bundle_processor('application/javascript', Requirejs::Tilt::Template)
        #env.register_engine('.js', Requirejs::Tilt::Template)
      end

    end
  end
end