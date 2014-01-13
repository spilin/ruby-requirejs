require 'requirejs/version'
require 'requirejs/config'

if defined?(Rails)
  require 'requirejs/rails/railtie'
else
  Requirejs.config = Requirejs::Config.new
end

module Requirejs

  def self.config=(config)
    @config = config
  end

  def self.config
    @config
  end

end
