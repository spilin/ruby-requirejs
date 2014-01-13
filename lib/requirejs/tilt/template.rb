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

      def prepare
      end

      # Internal: Compile the template Stylus using this instance options.
      # The current 'scope' and given 'locals' are ignored and the output
      # is cached.
      #
      # Returns a String with the compiled stylesheet with CSS syntax.
      def evaluate(scope, locals, &block)
        compiler = ::Requirejs::Compiler.new(scope: scope, data: data, file: file)
        if compiler.rjs?
          @output || compiler.exec
        else
          @output ||= data
        end
      end

    end
  end
end

Tilt.register Requirejs::Tilt::Template, 'js'
