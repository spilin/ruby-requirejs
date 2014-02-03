module Requirejs
  class StandardBuild
    def initialize(scope, file, original_data)
      @scope, @file = scope, file
      @original_data = original_data
    end

    def build
      <<-JS
        require.config({
          paths: #{ Manifest.new(@scope, @file).paths_as_json }
        });
        #{@original_data}
      JS
    end

  end
end