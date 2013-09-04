module Modernize
  class Parser
    # Executes a block to figure out the sets of translations and version.
    #
    def self.parse(&block)
      context = BlockParsingContext.new
      context.instance_exec(&block)
      context.migrations
    end
  end

  # Struct for storing the translations and block for determining version
  #
  class CompiledMigrations < Struct.new(:translations, :version, :order); end

  class VersionError < StandardError; end

  # Class for the context in which the block will get run
  #
  class BlockParsingContext
    attr_accessor :translations, :initial_version, :has_version, :order

    def initialize
      @translations = {}
      @initial_version = nil
      @has_version = false
      @order = :ascending
    end

    # Determines what versions there are and before + after if any.
    #
    def method_missing(method, *args, &block)
      raise NoMethodError.new("Undefined translation method #{method}") unless MetaMethods.respond_to?(method)
      MetaMethods.send(method, self, args, &block)
    end

    # Returns the struct of version block and translation sets
    # throws an error if no block is provided for determining version.
    #
    def migrations
      raise VersionError.new('did not provide a way to determine version') unless @has_version
      CompiledMigrations.new(@translations, @initial_version, @order)
    end
  end
end
