module Modernize
  class MetaMethods
    def modernize(parser, args, &block)
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 1)") if args.size != 1
      parser.translations[args[0]] = VersionParser.parse(&block)
    end

    def version(parser, args, &block)
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 0)") if args.size != 0
      parser.has_version = true
      parser.initial_version = block
    end

    def first(parser, args, &block)
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 0)") if args.size != 0
      parser.translations[:first] = VersionParser.parse(&block)
    end

    def last(parser, args, &block)
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 0)") if args.size != 0
      parser.translations[:last] = VersionParser.parse(&block)
    end
  end
end
