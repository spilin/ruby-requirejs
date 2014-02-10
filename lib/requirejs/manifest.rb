module Requirejs
  # Class responsible for proper assets paths generation that is used in standard non-almond build
  # with digest settings turned on - to properly map resources to their digested paths
  # Paths are stored in manifest file.
  class Manifest

    def initialize(scope, file)
      @scope, @file = scope, file
      @manifest_location = File.join(Requirejs.config.cache_build_scripts_location, 'manifest.yaml')
    end

    def paths
      if manifest_exists?
        read_paths_from_manifest
      else
        paths = extract_paths_from_environment
        save_manifest(paths)
        paths
      end
    end

    def paths_as_json
      JSON.pretty_generate(paths)
    end

    private

    def read_paths_from_manifest
      YAML.load(File.read(@manifest_location))
    end

    def manifest_exists?
      File.exists?(@manifest_location)
    end

    def extract_paths_from_environment
      {}.tap do |hash|
        @scope.environment.each_logical_path do |logical_path|
          next unless include_asset?(logical_path)
          hash[logical_path.gsub(/(^.*)\.js$/, '\1')] = @scope.path_to_asset(logical_path).gsub(/(^.*)\.js$/, '\1')
        end
      end
    end

    def include_asset?(logical_path)
      (logical_path =~/.*\.js$/) && (File.basename(logical_path) != File.basename(@file))
    end

    def save_manifest(paths)
      File.open(@manifest_location, 'w') do |f|
        f.write(YAML.dump(paths))
      end
    end

  end
end