module Modernize
  module MapMethods
    class << self
      # Adds a field based on the result of the block
      # if the field doesn't already exist.
      #
      def add(struct, field, block)
        h = struct.hash
        h[field] = struct.instance_exec(&block) if h[field].nil?
      end

      # Removes a field.
      #
      def remove(struct, field, block)
        struct.hash.delete(field)
      end

      # Maps an existing field passing the current value
      # as a parameter to the block.
      #
      def map(struct, field, block)
        h = struct.hash
        h[field] = struct.instance_exec(h[field], &block) unless h[field].nil?
      end

      # Adds or updates a field passing the current value (if any)
      # as a parameter to the block.
      #
      def compute(struct, field, block)
        h = struct.hash
        h[field] = struct.instance_exec(h[field], &block)
      end
    end
  end
end