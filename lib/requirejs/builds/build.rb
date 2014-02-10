module Requirejs
  class Build
    def initialize(scope, file, original_data)
      @scope, @file = scope, file
      @original_data = original_data
    end

    def data
      <<-JS
require.config({
  paths: #{ Manifest.new(@scope, @file).paths_as_json }
});
#{@original_data}
      JS
    end

  end
end