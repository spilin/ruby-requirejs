module Requirejs
  class Compiler
    attr_accessor :scope, :data, :file, :build_script_path

    def initialize(options ={})
      Requirejs.config.ensure_cache_location_exists
      @scope, @data, @file = options[:scope], options[:data], options[:file]
    end

    def exec
      if Requirejs.config.optimize_with_almond?
        AlmondBuild.new(@scope, @file, @data).build
      else
        StandardBuild.new(@scope, @file, @data).build
      end
    end

  end
end