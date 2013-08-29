module Modernize
  class MapMethods
    # adds a field based on the result of the block
    # if the field doesn't already exist
    #
    def add(struct, field, block)
      h = struct.hash
      h[field] = struct.instance_exec(&block) if h[field].nil?
    end

    # removes a field
    #
    def remove(struct, field, block)
      struct.hash.delete(field)
    end

    # computes an existing field passing the current value
    # as a parameter to the block
    #
    def compute(struct, field, block)
      h = struct.hash
      h[field] = struct.instance_exec(h[field], &block)
    end
  end
end