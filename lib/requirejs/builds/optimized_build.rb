module Requirejs
  class OptimizedBuild
    def initialize(scope, file, original_data)
      @scope, @file = scope, file
      @original_data = original_data
    end

    def prepare
      store_data_to_asset
      copy_assets
    end

    def data
      prepare
      ::Requirejs::Runtime.new(build_script).exec
      File.read(config.data[:out])
    end

    private

    def build_script
      build_script_path = File.join(Requirejs.config.gem_root_path, 'lib', 'requirejs', 'builds', 'build.js.erb')
      ERB.new(File.read(build_script_path)).result(binding)
    end

    # Store data in assets cache dir so it will be used in compilation
    def store_data_to_asset
      File.open(File.join(Requirejs.config.cache_assets_location, File.basename(@file)), 'w') do |f|
        f.write @original_data
      end
    end

    # Store assets in assets cache dir so we can use them during compilation
    def copy_assets
      @scope.environment.each_logical_path do |logical_path|
        copy_asset(logical_path) if copy_asset?(logical_path)
      end
    end

    def copy_asset(logical_path)
      @scope.environment.find_asset(logical_path).write_to(asset_path(logical_path))
    end

    def asset_path(logical_path)
      File.join(Requirejs.config.cache_assets_location, logical_path).to_s
    end

    def copy_asset?(logical_path)
      !File.exists?(asset_path(logical_path)) && (logical_path =~/.*\.js$/) && (File.basename(logical_path) != File.basename(@file))
    end

    def config
      @config ||= ::Requirejs::BuildConfig.new(@file)
    end

  end
end