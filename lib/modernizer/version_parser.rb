module Modernize
  class VersionParser
    # takes a block for a given version and generates the translations
    #
    def self.parse(&block)
      context = VersionParsingContext.new
      context.instance_exec(&block)
      context.migration
    end
  end

  # class for the context to executed the block in
  #
  class VersionParsingContext
    def initialize
      @maps = []
    end

    # figures out which translations are done for each version
    #
    def method_missing(method, *args, &block)
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 1)") if args.size != 1
      raise NoMethodError.new("Undefined translation method #{method}") unless MapMethods.new.respond_to?(method)
      @maps << {name: method, field: args[0], block: block}
    end

    # returns all the translations for a verion
    #
    def migration
      @maps
    end
  end
end