module Requirejs
  # Class handles storing and retrieving build config for each rjs-manifest file
  class BuildConfig

    def initialize(file)
      @file = file
    end

    def data
      @data ||= begin
        data = {
            wrap: true,
            baseUrl: Requirejs.config.cache_assets_location,
            optimize: Requirejs.config.js_compressor,
            out: File.join(Requirejs.config.cache_builds_location, basename)
        }.merge(config_from_file)
        data[:name] = 'almond' if Requirejs.config.almond?
        data
      end
    end

    def as_json
      JSON.dump(data)
    end

    # Dumps hash with build config to yaml file
    def save(hash)
      File.open(file_path, 'w') do |f|
        f.write(YAML.dump(hash))
      end
    end

    def exists?
      File.exists?(file_path)
    end

    private

    def file_path
      File.join(Requirejs.config.cache_build_scripts_location, "#{name}.yaml")
    end

    # Read config from file
    def config_from_file
      YAML.load(File.read(file_path))
    end

    # The basename of the template file.
    def basename(suffix='')
      File.basename(@file, suffix)
    end

    # The template file's basename with all extensions chomped off.
    def name
      basename.split('.', 2).first if basename
    end

  end
end