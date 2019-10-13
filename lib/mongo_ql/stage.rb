# frozen_string_literal: true

module MongoQL
  class Stage
    
    def to_ast
      raise NotImplementedError, "stage #{self.class} must implement to_ast"
    end
  end
end