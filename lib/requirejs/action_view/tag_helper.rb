module Requirejs
  module ActionView
    module TagHelper
      def requirejs_include_tag(*sources)
        if Requirejs.config.optimize_with_almond?
          javascript_include_tag(*sources)
        else
          sources.uniq.map do |source|
            javascript_include_tag('require', data: { main: path_to_javascript(source).gsub!(/(^.*)\.js$/, '\1') })
          end.join("\n").html_safe
        end
      end
    end
  end
end