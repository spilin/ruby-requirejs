module Requirejs
  class Config < ::ActiveSupport::OrderedOptions
    def initialize
      super

      self.gem_root_path = Gem::Specification.find_by_name('ruby-requirejs').gem_dir
      self.runtime_location = File.join(gem_root_path, 'lib', 'requirejs', 'runtime', 'r.js')
      self.cache_location = nil
      self.js_compressor = :none # :uglify

      self.loader = :requirejs # :almond
      self.optimize = false # :almond
      self.digest = false # :almond
    end

    def cache_assets_location
      check_cache_location
      @cache_assets_location ||= File.join(cache_location, 'assets')
    end

    def cache_build_scripts_location
      check_cache_location
      @cache_build_scripts_location ||= File.join(cache_location, 'build_scripts')
    end

    def cache_builds_location
      check_cache_location
      @cache_builds_location ||= File.join(cache_location, 'builds')
    end

    def check_cache_location
      raise 'cache location is not set. Set cache_location. Ex.: Require.config.cache_location  = File.dirname(__FILE__)' if cache_location.blank?
    end

    def setup_directories
      cleanup_cache_dir
      ensure_cache_location_exists
    end

    def ensure_cache_location_exists
      [cache_location, cache_assets_location, cache_build_scripts_location, cache_builds_location].each do |path|
        Pathname.new(path).mkpath
      end
    end

    def cleanup_cache_dir
      FileUtils.remove_entry_secure(self.cache_location) rescue nil
    end

    def almond?
      self.loader == :almond
    end

    def optimize?
      almond? || self.optimize
    end

    def digest?
      self.digest
    end

  end

  # Config accessors
  def self.config=(config)
    @config = config
  end

  def self.config
    @config
  end
end
