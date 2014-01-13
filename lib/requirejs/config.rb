module Requirejs
  class Config < ::ActiveSupport::OrderedOptions
    def initialize
      super

      self.gem_root_path = Gem::Specification.find_by_name('ruby-requirejs').gem_dir
      self.runtime_location = File.join(gem_root_path, 'lib', 'requirejs', 'runtime', 'r.js')
      self.cache_location = ::Rails.root.join('tmp', 'ruby-requirejs')
      self.cache_assets_location = File.join(cache_location, 'assets')
      self.cache_build_scripts_location = File.join(cache_location, 'build_scripts')
      self.cache_builds_location = File.join(cache_location, 'builds')
      self.build_script_template_location = File.join(gem_root_path, 'lib', 'requirejs','build.js.erb')

      self.js_compressor = 'none' # :uglify

      self.loader = :requirejs # :almond
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

    def optimize_with_almond?
      self.loader == :almond
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
