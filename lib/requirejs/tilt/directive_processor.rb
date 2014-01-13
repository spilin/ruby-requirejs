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
    class DirectiveProcessor < ::Sprockets::DirectiveProcessor

      # Internal: Compile the template Stylus using this instance options.
      # The current 'scope' and given 'locals' are ignored and the output
      # is cached.
      #
      # Returns a String with the compiled stylesheet with CSS syntax.
      def evaluate(scope, locals, &block)
        @result = super
        if process_rjs?
          Requirejs.config.setup_directories
          dump_config
        end
        @result
      end

      def dump_config
        File.open(File.join(Requirejs.config.cache_build_scripts_location, "#{name}.yaml"), 'w') do |f|
          process_include_directive(name)
          f.write(YAML.dump('include' => @include_modules))
        end
      end

      protected

      def process_rjs_directive(*args)
        @rjs_directive_present = directives.any? { |directive| directive[1] == 'rjs' }
      end

      def process_include_directive(mod)
        @include_modules ||= []
        @include_modules << mod
      end

      def process_rjs?
        @rjs_directive_present
      end

    end
  end
end
