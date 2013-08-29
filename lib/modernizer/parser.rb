module Modernize
  class Parser
    # executes a block to figure out the sets of translations and version
    #
    def self.parse(&block)
      context = BlockParsingContenxt.new
      context.instance_exec(&block)
      context.migrations
    end
  end

  # struct for storing the translations and block for determining version
  #
  class CompiledMigrations < Struct.new(:translations, :version); end

  class VersionError < StandardError; end

  # class for the context in which the block will get run
  #
  class BlockParsingContenxt
    attr_accessor :translations, :initial_version, :has_version

    def initialize
      @translations = {}
      @initial_version = nil
      @has_version = false
    end

    # determines what versions there are and before + after if any
    #
    def method_missing(method, *args, &block)
      raise NoMethodError.new("Undefined translation method #{method}") unless MetaMethods.new.respond_to?(method)
      MetaMethods.new.send(method, self, args, &block)
    end

    # returns the struct of version block and translation sets
    # throws an error if no block is provided for determining version
    #
    def migrations
      raise VersionError.new('did not provide a way to determine version') unless @has_version
      CompiledMigrations.new(@translations, @initial_version)
    end
  end
end
