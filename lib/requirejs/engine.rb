module Requirejs
  class Engine < ::Rails::Engine

    config.before_configuration do
      config.requirejs = Requirejs.config = Requirejs::Config.new
      Requirejs.config.cache_location = ::Rails.root.join('tmp', 'ruby-requirejs')
    end

    config.assets.configure do |env|
      # Switching to rjs javascript compressor
      if env.js_compressor && env.js_compressor.name == 'Sprockets::UglifierCompressor'
        config.requirejs.js_compressor = :uglify
      else
        :none
      end

      # Disable default assets pipeline compression
      env.js_compressor = nil

      config.requirejs.digest = config.assets.digest

      # Changing Processors
      require 'requirejs/tilt/template'
      require 'requirejs/tilt/directive_processor'
      env.unregister_processor('application/javascript', Sprockets::DirectiveProcessor)
      env.register_preprocessor('application/javascript', Requirejs::Tilt::DirectiveProcessor)

      if Requirejs.config.optimize?
        config.assets.precompile << 'require.js' unless Requirejs.config.almond?
      else
        # Ready to precompile everything
        config.assets.precompile += env.paths.map { |path| Dir.glob(File.join(path, '**', '*.{js,coffee}')) }.flatten.uniq
        config.assets.uniq!
      end

      env.register_bundle_processor('application/javascript', Requirejs::Tilt::Template)
    end

  end
end