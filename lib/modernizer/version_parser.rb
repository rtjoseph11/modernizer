module Modernize
  class VersionParser
    # Takes a block for a given version and generates the translations.
    #
    def self.parse(&block)
      context = VersionParsingContext.new
      context.instance_exec(&block)
      context.migration
    end
  end

  # Class for the context to executed the block in.
  #
  class VersionParsingContext
    def initialize
      @maps = []
    end

    # Figures out which translations are done for each version.
    #
    def method_missing(method, *args, &block)
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 1)") if args.size != 1
      raise NoMethodError.new("Undefined translation method #{method}") unless MapMethods.respond_to?(method)
      @maps << {name: method, field: args[0], block: block}
    end

    # Returns all the translations for a verion.
    #
    def migration
      @maps
    end
  end
end