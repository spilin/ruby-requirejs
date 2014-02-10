module Helpers

  def create_app(options = {})
    Rails.application = nil

    Class.new(Rails::Application).tap do |app|
      app.assets.cache = ActiveSupport::Cache.lookup_store(:null_store)
      config = app.config.assets

      config.js_compressor = options[:js_compressor]
      config.digest = options[:digest]
      config.debug = options[:debug]
      config.paths = []
      config.paths << options[:assets_path] if options[:assets_path]
      yield(app) if block_given?

      app.config.eager_load = false
      app.config.active_support.deprecation = :log
      app.initialize!
    end
  end

  def fixtures_path(name)
    File.join(File.dirname(File.expand_path('../..', __FILE__)), 'spec', 'cases', name, 'in')
  end

  def compiled_asset_path(name)
    File.join(File.dirname(File.expand_path('../..', __FILE__)), 'spec', 'cases', name, 'out')
  end

  def compiled_asset(name, file_name)
    File.read(File.join(compiled_asset_path(name), file_name))
  end

  def dump_asset(asset)
    File.open File.expand_path('../../cases/tmp.js', __FILE__), 'w+' do |f|
      f.write asset.to_s
    end
  end
end
