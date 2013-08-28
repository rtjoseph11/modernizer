require 'modernizer/version'
require 'modernizer/map_methods'
require 'modernizer/meta_methods'
require 'modernizer/version_parser'
require 'modernizer/parser'

module Modernize
  class Modernizer
    def initialize(&block)
      @migrations = Parser.parse(&block)
      @variables = block.parameters.map {|value| value[1]}
      @struct = StructContext.new(@variables)
    end

    def translate(*params)
      raise ArgumentError.new('did not provide expeceted params') if params.size != @variables.size
      @variables.map do |value|
        @struct.send((value.to_s + '=').to_sym, params.shift)
      end
      map = MapMethods.new
      translate = lambda { |translation|
        map.send(translation[:name], @struct, @variables.last, translation[:field], translation[:block])
      }

      struct_version = @struct.instance_exec(&@migrations.version)
      firsts = @migrations.translations.delete(:first)
      lasts = @migrations.translations.delete(:last)
      migration_versions = @migrations.translations.keys.sort! do |x,y|
        Gem::Version.new(x) <=> Gem::Version.new(y)
      end
      
      firsts.each(&translate) if firsts

      first_index = migration_versions.find_index(struct_version)
      migration_versions.each_with_index do |version, index|
        next unless index >= first_index
        @migrations.translations[version].each(&translate)
      end

      lasts.each(&translate) if lasts

      @struct.send(@variables.last)
    end
  end

  private
  class StructContext
    def initialize(params)
      params.each do |value|
        create_attr(value)
      end
    end

    def create_method(name, &block)
      self.class.send(:define_method, name, &block)
    end

    def create_attr(name)
      create_method("#{name}=".to_sym) do |val|
        instance_variable_set(:"@#{name}", val)
      end

      create_method(name.to_sym) do
        instance_variable_get(:"@#{name}")
      end
    end
  end
end
