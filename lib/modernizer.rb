require 'modernizer/version'
require 'modernizer/map_methods'
require 'modernizer/meta_methods'
require 'modernizer/version_parser'
require 'modernizer/parser'

module Modernize
  class Modernizer
    def initialize(&block)
      @migrations = Parser.parse(&block)
    end

    def translate(env, body)
      req = RequestContext.new(env, body)
      map = MapMethods.new
      translate = lambda { |translation|
        map.send(translation[:name], req, translation[:field], translation[:block])
      }

      request_version = req.instance_exec(&@migrations.version)
      firsts = @migrations.translations.delete(:first)
      lasts = @migrations.translations.delete(:last)
      migration_versions = @migrations.translations.keys.sort! do |x,y|
        Gem::Version.new(x) <=> Gem::Version.new(y)
      end
      
      firsts.each(&translate) if firsts

      first_index = migration_versions.find_index(request_version)
      migration_versions.each_with_index do |version, index|
        next unless index >= first_index
        @migrations.translations[version].each(&translate)
      end

      lasts.each(&translate) if lasts

      body
    end
  end

  private
  class RequestContext
    attr_accessor :env, :body

    def initialize(env, body)
      @env = env
      @body = body
    end
  end
end
