module Modernize
  class MapMethods
    def add(struct, hash, field, block)
      h = struct.send(hash)
      h[field] = struct.instance_exec(&block) if h[field].nil?
    end

    def remove(struct, hash, field, block)
      struct.send(hash).delete(field)
    end

    def compute(struct, hash, field, block)
      h = struct.send(hash)
      h[field] = struct.instance_exec(h[field], &block)
    end
  end
end