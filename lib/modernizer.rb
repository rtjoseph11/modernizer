require "modernizer/version"
require "modernizer/map_methods"
require "modernizer/meta_methods"
require "modernizer/version_parser"
require "modernizer/parser"

module Modernize
  class Modernizer
    def initialize(&block)
      @struct = Parser.parse(&block)
    end

    def translate(env, hash)
      request_version = @struct.version.call(env)
      # TODO: sort versions
      migration_versions = @struct.translations.keys
      first_index = migration_versions.find_index(request_version)
      migration_versions.each_with_index do |version, index|
        next unless index >= first_index
        @struct.translations[version].each do |translation|
          MapMethods.new.send(translation[:name], env, hash, translation[:field], translation[:block])
        end
      end
      hash
    end
  end
end
