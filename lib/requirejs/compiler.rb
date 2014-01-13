module Requirejs
  class Compiler
    attr_accessor :scope, :data, :file, :build_script_path

    def initialize(options ={})
      @scope, @data, @file = options[:scope], options[:data], options[:file]
      @build_script_path = File.join(Requirejs.config.cache_build_scripts_location, basename)
    end

    def exec
      if Requirejs.config.optimize_with_almond?
        almond_loader_build
      else
        standart_loader_build
      end
    end

    def almond_loader_build
      store_data_to_asset
      copy_assets
      generate_build_script
      execute_rjs
      File.read(config.out)
    end

    # Inlude paths so rquirejs can associate modules with fingreprinted files
    def standart_loader_build
      <<-SQL
        require.config({
          paths: #{ JSON.pretty_generate( paths_manifest ) }
        });
        #{data}
      SQL
    end

    def config
      @config ||= OpenStruct.new(YAML.load(File.read(config_file_path)).merge({ out: File.join(Requirejs.config.cache_builds_location, basename) }))
    end

    def rjs?
      File.exists?(config_file_path)
    end

    private

    def paths_manifest
      manifest_location = File.join(Requirejs.config.cache_build_scripts_location, 'manifest.yaml')
      return YAML.load(File.read(manifest_location)) if File.exists?(manifest_location)
      paths = {}.tap do |hash|
        scope.environment.each_logical_path do |logical_path|
          hash[logical_path.gsub(/(^.*)\.js$/, '\1')] = scope.path_to_asset(logical_path).gsub(/(^.*)\.js$/, '\1') if copy_asset?(logical_path)
        end
      end
      File.open(manifest_location, 'w') do |f|
        f.write(YAML.dump(paths))
      end
      paths
    end

    # Store data in assets cache dir so we can use it will be used in compilation
    def store_data_to_asset
      File.open(File.join(Requirejs.config.cache_assets_location, basename), 'w') do |f|
        f.write data
      end
    end

    # Store assets in assets cache dir so we can use them during compilation
    def copy_assets
      scope.environment.each_logical_path do |logical_path|
        copy_asset(logical_path) if copy_asset?(logical_path)
      end
    end

    def copy_asset(logical_path)
      scope.environment.find_asset(logical_path).write_to(asset_path(logical_path))
    end

    def asset_path(logical_path)
      File.join(Requirejs.config.cache_assets_location, logical_path).to_s
    end

    def copy_asset?(logical_path)
      !File.exists?(asset_path(logical_path)) && (logical_path =~/.*\.js$/) && (File.basename(logical_path) != basename)
    end

    def generate_build_script
      File.open(build_script_path, 'w') do |f|
        f.write ERB.new(File.read(Requirejs.config.build_script_template_location)).result(binding)
      end
    end

    def execute_rjs
      `node "#{build_script_path}"`
    end

    # The basename of the template file.
    def basename(suffix='')
      File.basename(file, suffix) if file
    end

    # The template file's basename with all extensions chomped off.
    def name
      basename.split('.', 2).first if basename
    end

    def config_file_path
      @config_file_path ||= File.join(Requirejs.config.cache_build_scripts_location, "#{name}.yaml")
    end

  end
end