module Requirejs
  class Compiler
    attr_accessor :scope, :data, :file, :build_script_path

    def initialize(options ={})
      Requirejs.config.ensure_cache_location_exists
      @scope, @data, @file = options[:scope], options[:data], options[:file]
    end

    def exec
      if Requirejs.config.optimize?
        OptimizedBuild.new(@scope, @file, @data).data
      elsif Requirejs.config.digest?
        Build.new(@scope, @file, @data).data
      else
        @data
      end
    end

  end
end