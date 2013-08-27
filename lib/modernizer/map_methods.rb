module Modernize
  class MapMethods
    def add(env, obj, field, block)
      obj[field.to_s] = block.call
    end

    def remove(env, obj, field, block)
      obj.delete(field.to_s) || obj.delete(field.to_sym)
    end

    def compute(env, obj, field, block)
      obj[field.to_s] = block.call(env, obj)
    end
  end
end