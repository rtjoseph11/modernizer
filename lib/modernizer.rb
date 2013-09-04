require 'modernizer/version'
require 'modernizer/map_methods'
require 'modernizer/meta_methods'
require 'modernizer/version_parser'
require 'modernizer/parser'

module Modernize
  class Modernizer

    # Generates the set of migrations by parsing the passed in block
    #
    def initialize(&block)
      @migrations = Parser.parse(&block)
    end

    # Translates a hash based on defined migrations
    # with a given context and returns the hash.
    # This will modify whatever gets passed in.
    #
    def translate(context, hash)
      # makes sure that the context is a hash
      raise ArgumentError.new('did not pass a hash for the context') unless context.is_a?(Hash)
      raise ArgumentError.new('cannot provide include hash in context') if context[:hash]
      # create the context instance for instance variables
      struct = StructContext.new(context, hash)

      # instantiate MapMethods to perform translations and define lambda
      # for how to tranlate a field
      #

      translate = lambda { |t|
        MapMethods.send(t[:name], struct, t[:field], t[:block])
      }

      # determine the version of the incoming hash
      #
      struct_version = struct.instance_exec(&@migrations.version)

      raise StandardError.new('calculated version is not valid') unless Gem::Version.correct?(struct_version)

      # get the first and last translations
      #
      firsts = @migrations.translations.delete(:first)
      lasts = @migrations.translations.delete(:last)

      # gets a list of the potential versions and then sorts them
      #
      migration_versions = @migrations.translations.keys.sort! do |x,y|
        Gem::Version.new(x) <=> Gem::Version.new(y)
      end

      # reverse order if descending was specified
      #
      migration_versions = @migrations.order == :descending ? migration_versions.reverse : migration_versions
      # run the first translations if they exist
      #
      firsts.each(&translate) if firsts

      # determine the first version to run translations
      #
      first_index = @migrations.order == :ascending ? migration_versions.find_index(struct_version) : nil
      last_index = @migrations.order == :descending ? migration_versions.find_index(struct_version) : nil

      # run all subsequent version translations
      #
      migration_versions.each_with_index do |version, index|
        next unless !first_index || index >= first_index
        next unless !last_index || index <= last_index
        @migrations.translations[version].each(&translate)
      end

      # run the first translations if they exist
      #
      lasts.each(&translate) if lasts

      # return hash
      #
      struct.hash
    end
  end

  private

  # This class is used to make the context key/values available
  # as instance variables to the map methods.
  #
  class StructContext
    def initialize(context, hash)
      create_getter(:hash, hash)
      context.each do |key, value|
        create_getter(key, value)
      end
    end

    # Helper method which wraps define_method.
    #
    def create_method(name, &block)
      self.class.send(:define_method, name, &block)
    end

    # Creates getters for each instance variable and sets
    # the initial value.
    #
    def create_getter(name, value)
      instance_variable_set(:"@#{name}", value)
      create_method(name.to_sym) do
        instance_variable_get(:"@#{name}")
      end
    end
  end
end
