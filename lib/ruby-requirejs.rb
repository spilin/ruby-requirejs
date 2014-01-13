require 'requirejs/version'
require 'requirejs/config'
require 'requirejs/compiler'

if defined?(Rails)
  require 'requirejs/engine'
else
  Requirejs.config = Requirejs::Config.new
end

# Loading ActionView helpers
if defined?(::ActionView)
  require 'requirejs/action_view/tag_helper'
  ::Requirejs::ActionView.constants.each do |k|
    klass = ::Requirejs::ActionView.const_get(k)
    ActionView::Base.send(:include, klass) if klass.is_a?(Module)
  end
end

module Requirejs
end
