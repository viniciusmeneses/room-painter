module Micro
  class Case
    private

    def __call_use_case
      klass = self.class

      begin
        schema = klass::Schema.call(attributes)
        return Failure(:invalid_attributes, result: schema.errors.to_h) if schema.failure?
        self.attributes = schema.to_h
      rescue
      end

      result = call!

      return result if result.is_a?(Result)

      raise Error::UnexpectedResult.new("#{klass.name}#call!")
    end
  end
end
