module Requirejs
  class AlmondBuild
    def initialize(scope, file, original_data)
      @scope, @file = scope, file
      @original_data = original_data
    end

    def prepare
      store_data_to_asset
      copy_assets
    end

    def build
      prepare
      ::Requirejs::Runtime.new(build_script).exec
      File.read(config.out)
    end

    private

    def build_script
      ERB.new(File.read(Requirejs.config.build_script_template_location)).result(binding)
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
      @config ||= ::Requirejs::BuildConfig.new(@file).read
    end

  end
end