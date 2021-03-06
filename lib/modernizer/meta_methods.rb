module Modernize
  module MetaMethods
    class << self

      # Defines a set of translations to run in order to modernizer
      # a given version.
      #
      def modernize(parser, args, &block)
        raise ArgumentError.new("wrong number of arguments (#{args.size} for 1)") if args.size != 1
        raise StandardError.new('version is not valid') unless Gem::Version.correct?(args[0])
        parser.translations[args[0]] = VersionParser.parse(&block)
      end

      # Stores the block for determining the version.
      #
      def version(parser, args, &block)
        raise ArgumentError.new("wrong number of arguments (#{args.size} for 0)") if args.size != 0
        parser.has_version = true
        parser.initial_version = block
      end

      # Method for setting the translations which get run before any others,
      #
      def first(parser, args, &block)
        raise ArgumentError.new("wrong number of arguments (#{args.size} for 0)") if args.size != 0
        parser.translations[:first] = VersionParser.parse(&block)
      end

      # Method for setting the translations which get run after any others.
      #
      def last(parser, args, &block)
        raise ArgumentError.new("wrong number of arguments (#{args.size} for 0)") if args.size != 0
        parser.translations[:last] = VersionParser.parse(&block)
      end

      # Sets the order of translations to be ascending i.e.
      # first do version 0.0.1 then version 0.0.2 etc.
      #
      def ascending(parser, args, &block)
        raise ArgumentError.new("wrong number of arguments (#{args.size} for 0)") if args.size != 0
        parser.order = :ascending
      end

      # Sets the order of translations to be descending i.e.
      # first do version 0.0.9 then version 0.0.8 etc.
      #
      def descending(parser, args, &block)
        raise ArgumentError.new("wrong number of arguments (#{args.size} for 0)") if args.size != 0
        parser.order = :descending
      end
    end
  end
end
