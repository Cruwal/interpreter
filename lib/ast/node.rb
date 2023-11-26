module Ast
  module Node
    def token_literal
      raise NotImplementedError, "Subclasses must implement the 'token_literal' method"
    end

    def debug
      raise NotImplementedError, "Subclasses must implement the 'debug' method"
    end
  end
end
