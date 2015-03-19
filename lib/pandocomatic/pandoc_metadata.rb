module Pandocomatic

  require 'json'
  require 'yaml'
  require 'paru/pandoc'

  require_relative 'configuration.rb'

  class PandocMetadata < Hash

    def initialize hash = {}
      super
      merge! hash
    end

    # Collect the metadata embedded in the src file
    def self.load_file src
      begin
        json_reader = Paru::Pandoc.new {from 'markdown'; to 'json'}
        json_document = JSON.parse json_reader << File.read(src)
        if json_document.first["unMeta"].empty? then
          return PandocMetadata.new 
        else
          json_metadata = [json_document.first, []]
          json_writer = Paru::Pandoc.new {from 'json'; to 'markdown'; standalone}
          yaml_metadata = json_writer << JSON.generate(json_metadata)
          return PandocMetadata.new YAML.load yaml_metadata
        end
      rescue Exception => e
        raise "Error while reading metadata from #{src}; Are you sure it is a pandoc markdown file?\n#{e.message}"
      end
    end

    def has_template?
      has_key? 'pandocomatic' and self['pandocomatic'].has_key? 'use-template'
    end

    def template
      if has_template? then
        self['pandocomatic']['use-template']
      else
        ''
      end
    end

    def has_pandoc_options?
      has_key? 'pandocomatic' and self['pandocomatic'].has_key? 'pandoc'
    end

    def pandoc_options
      if has_pandoc_options? then
        self['pandocomatic']['pandoc']
      else
        {}
      end
    end

    def to_configuration parent_config = Configuration.new
    end

  end

end
