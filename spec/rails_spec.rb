require 'spec_helper'

describe 'Rails' do

  describe 'configuration' do
    it 'sets Rails.config.requirejs' do
      create_app
      ::Rails.configuration.requirejs.should be_a(::Requirejs::Config)
    end

    it 'sets cache_location' do
      create_app
      Requirejs.config.cache_location.should == ::Rails.root.join('tmp', 'ruby-requirejs')
    end

    it 'sets js_compressor no "none" as default' do
      create_app
      Requirejs.config.js_compressor.should == :none
    end

    it 'sets js_compressor to "uglify" when this config.assets.js_compressor set to :uglifier' do
      create_app(:js_compressor => :uglifier)
      Requirejs.config.js_compressor.should == :uglify
    end

    it 'disables default asset pipeline' do
      create_app
      ::Rails.configuration.assets.js_compressor.should be_nil
    end

  end

  describe 'compilation' do
    after { Requirejs.config.cleanup_cache_dir }

    describe 'not minified almond setup' do
      it 'compresses to one file' do
        app = create_app(assets_path: fixtures_path('basic_almond'))
        app.config.requirejs.loader = :almond
        asset = app.assets['application']
        asset.to_s.should == compiled_asset('basic_almond', 'application.js').to_s
      end
    end

    describe 'minified almond setup' do
      it 'compresses to one minified file' do
        app = create_app(assets_path: fixtures_path('basic_minimized_almond'), :js_compressor => :uglifier)
        app.config.requirejs.loader = :almond
        asset = app.assets['application']
        asset.to_s.should == compiled_asset('basic_minimized_almond', 'application.js').to_s
      end
    end

    describe 'unoptimized requirejs setup' do
      it 'compresses to one file' do
        app = create_app(assets_path: fixtures_path('basic'))
        asset = app.assets['application']
        asset.to_s.should == compiled_asset('basic', 'application.js').to_s
      end
    end

    describe 'unoptimized requirejs setup with digested assets' do
      it 'compresses to one file' do
        app = create_app(assets_path: fixtures_path('basic_digested'), digest: true)
        asset = app.assets['application']
        asset.to_s.should == compiled_asset('basic_digested', 'application.js').to_s
      end
    end

    describe 'optimized requirejs setup' do
      it 'compresses to one file' do
        app = create_app(assets_path: fixtures_path('basic_optimized'))
        app.config.requirejs.optimize = true
        asset = app.assets['application']
        asset.to_s.should == compiled_asset('basic_optimized', 'application.js').to_s
      end
    end
  end

end
