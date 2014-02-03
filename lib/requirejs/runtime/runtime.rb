require 'execjs'

module Requirejs
  # Internal: Module responsible for the ExecJS interaction. Besides handling
  # the compilation execution, this module provide a runtime validation to ensure
  # that the Node.JS binary is available to use.
  class Runtime

    # Internal: Module responsible for the ExecJS interaction. Besides handling
    # the compilation execution, this module provide a runtime validation to ensure
    # that the Node.JS binary is available to use.
    def initialize(build_script)
      @build_script = build_script
    end

    # Internal: Calls a specific function on the Node.JS context.
    #
    # Example
    #  exec('version', 2) # => '2'
    #
    # Returns The function returned value.
    def exec(*arguments)
      check_availability!
      context.call('optimize')
    end

    #private
    # Internal: Queries the runtime for it's availability and raises a 'RuntimeError'
    # if the runtime isn't available. Otherwise, this is a noop.
    def check_availability!
      unless runtime.available?
        message = 'The Node.JS runtime is not available to RequireJS.'
        message << 'Ensure that the "node" (or "nodejs") executable is present in your $PATH.'
        raise RuntimeError, message
      end
    end

    # Internal: Compile the Stylus compilation script into a execution context
    # to execute functions into.
    #
    # Returns the compiled context.
    def context
      @context ||= runtime.compile(@build_script)
    end

    # Internal: Create the ExecJS external runtime with a old runner script that
    # maintains the state of 'require', so we can use it to load modules like on
    # any Node.JS program.
    def runtime
      #@runtime ||= ExecJS::Runtimes::Node
      @runtime ||= ExecJS::ExternalRuntime.new(
          :name => 'Node.js (V8)',
          :command => %w{nodejs node},
          :runner_path => File.expand_path('../node_runner.js', __FILE__),
          :encoding => 'UTF-8'
      )
    end
  end
end
