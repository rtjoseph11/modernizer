module Modernize
  class Parser
    def self.parse(&block)
      context = BlockParsingContenxt.new
      context.instance_exec(&block)
      context.migrations
    end
  end

  class CompiledMigrations < Struct.new(:translations, :version); end

  class VersionError < StandardError; end


  class BlockParsingContenxt
    attr_accessor :translations, :initial_version, :has_version

    def initialize
      @translations = {}
      @initial_version = nil
      @has_version = false
    end

    def method_missing(method, *args, &block)
      raise NoMethodError.new("Undefined translation method #{method}") unless MetaMethods.new.respond_to?(method)
      MetaMethods.new.send(method, self, args, &block)
    end

    def migrations
      raise VersionError.new("did not provide a way to determine version") unless @has_version
      CompiledMigrations.new(@translations, @initial_version)
    end
  end
end
