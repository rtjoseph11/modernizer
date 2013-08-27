module Modernize
  class VersionParser
    def self.parse(&block)
      context = VersionParsingContext.new
      context.instance_exec(&block)
      context.migration
    end
  end

  class VersionParsingContext
    def initialize
      @maps = []
    end

    def method_missing(method, *args, &block)
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 1)") if args.size != 1
      raise NoMethodError.new("Undefined translation method #{method}") unless MapMethods.new.respond_to?(method)
      @maps << {name: method, field: args[0], block: block}
    end

    def migration
      @maps
    end
  end
end