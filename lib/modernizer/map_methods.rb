module Modernize
  class MapMethods
    def add(struct, hash, field, block)
      struct.send(hash)[field] = struct.instance_exec(&block) if struct.send(hash)[field].nil?
    end

    def remove(struct, hash, field, block)
      struct.send(hash).delete(field)
    end

    def compute(struct, hash, field, block)
      struct.send(hash)[field] = struct.instance_exec(struct.send(hash)[field], &block)
    end
  end
end