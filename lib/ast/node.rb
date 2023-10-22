module Ast
  module Node
    def token_literal
      raise NotImplementedError, "Subclasses must implement the 'token_literal' method"
    end
  end
end
