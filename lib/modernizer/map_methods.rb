module Modernize
  class MapMethods
    def add(request, field, block)
      request.body[field] = request.instance_exec(&block) if request.body[field].nil?
    end

    def remove(request, field, block)
      request.body.delete(field)
    end

    def compute(request, field, block)
      request.body[field] = request.instance_exec(request.body[field], &block)
    end
  end
end