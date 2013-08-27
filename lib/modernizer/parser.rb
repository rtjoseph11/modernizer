module Modernize
  class Parser
    def self.parse(&block)
      context = BlockParsingContenxt.new
      context.instance_exec(&block)
      context.migrations
    end
  end

  class CompiledMigrations < Struct.new(:translations, :version); end


  class BlockParsingContenxt
    attr_accessor :translations, :version, :has_version

    def initialize
      @translations = {}
      @version = nil
      @has_version = false
    end

    def method_missing(method, *args, &block)
      raise NoMethodError.new("Undefined translation method #{method}") unless MetaMethods.new.respond_to?(method)
      MetaMethods.new.send(method, self, args, &block)
    end

    def migrations
      raise ArgumentError.new("did not provide a way to determine version") unless @has_version
      CompiledMigrations.new(@translations, @version)
    end
  end
end
