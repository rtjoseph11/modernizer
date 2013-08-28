module Modernize
  class MapMethods
    def add(struct, field, block)
      struct.hash[field] = struct.instance_exec(&block) if struct.hash[field].nil?
    end

    def remove(struct, field, block)
      struct.hash.delete(field)
    end

    def compute(struct, field, block)
      struct.hash[field] = struct.instance_exec(struct.hash[field], &block)
    end
  end
end