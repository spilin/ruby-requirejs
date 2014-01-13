require 'tilt'
# Public: A Tilt template to compile Stylus stylesheets.
#
# Examples
#
#  template = Tilt::StylusTemplate.new { |t| File.read('app.styl') }
#  template.render # => the compiled CSS from the app.styl file.
#
#  Options should assigned on the template constructor.
#  template = Tilt::StylusTemplate.new(compress: true) { |t| File.read('app.styl') }
#  template.render # => the compiled CSS with compression enabled.
module Requirejs
  module Tilt
    class Template < ::Tilt::Template
      # Public: The default mime type for stylesheets.
      self.default_mime_type = 'application/javascript'

      # Internal: Checks if the Stylus module has been properly defined.
      #
      # Returns true if the 'Stylus' module is present.
      def self.engine_initialized?
        defined? ::Requirejs
      end

      # Internal: Require the 'stylus' file to load the Stylus module.
      #
      # Returns nothing.
      def initialize_engine
        require_template_library 'requirejs'
      end

      # Internal: Caches the filename as an option entry if it's present.
      #
      # Returns nothing.
      def prepare
        #super
      end

      # Internal: Compile the template Stylus using this instance options.
      # The current 'scope' and given 'locals' are ignored and the output
      # is cached.
      #
      # Returns a String with the compiled stylesheet with CSS syntax.
      def evaluate(scope, locals, &block)
        Requirejs.config.ensure_cache_location_exists

        if process_rjs?

          # Store rjs_file
          File.open(File.join(Requirejs.config.cache_assets_location, basename), 'w') do |f|
            f.write data
          end

          # Copy js files
          scope.environment.each_logical_path do |logical_path|
            if logical_path =~/.*\.js$/ && File.basename(logical_path) != basename
              path = File.join(Requirejs.config.cache_assets_location, logical_path)
              scope.environment.find_asset(logical_path).write_to(path.to_s)
            end
          end

          # Copy requirejs and almond
          FileUtils.cp_r(File.join(Requirejs.config.gem_root_path, 'vendor', 'assets', 'javascripts', '.'), Requirejs.config.cache_assets_location)

          #Generate build.js
          build_file_path = File.join(Requirejs.config.cache_build_scripts_location, basename)
          File.open(build_file_path, 'w') do |f|
            f.write ERB.new(File.read(Pathname.new(File.dirname(__FILE__) + '/../build.js.erb').to_s)).result(binding)
          end

          #BUILD build.js
          `node "#{build_file_path}"`

          #@output ||= Stylus.compile(data, options)
          @output ||= File.read(out_path)
        else
          @output ||= data
        end
      end

      def out_path
        @out_path ||= File.join(Requirejs.config.cache_builds_location, File.basename(file)).to_s
      end

      def process_rjs?
        File.exists?(config_file_path)
      end

      def config
        @config ||= YAML.load(File.read(config_file_path))
      end

      def config_file_path
        @config_file_path ||= File.join(Requirejs.config.cache_build_scripts_location, "#{File.basename(file, '.js')}.yaml")
      end

    end
  end
end

Tilt.register Requirejs::Tilt::Template, 'js'
