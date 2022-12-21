class ApplicationUseCase < Micro::Case
  def call!
    klass = self.class
    if klass.const_defined?(:Schema)
      schema = klass::Schema.call(attributes)
      return Failure(:invalid_attributes, result: schema.errors.to_h) if schema.failure?
      schema.output.map { |attribute, value| instance_variable_set("@#{attribute}", value) }
    end

    execute
  end
end
