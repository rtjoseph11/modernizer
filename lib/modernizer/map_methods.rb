module Modernize
  class MapMethods
    def add(request, field, block)
      request.body[field.to_s] = request.instance_exec &block if request.body[field.to_s].nil?
    end

    def remove(request, field, block)
      request.body.delete(field.to_s) || request.body.delete(field.to_sym)
    end

    def compute(request, field, block)
      request.body[field.to_s] = request.instance_exec request.body[field.to_s], &block
    end
  end
end