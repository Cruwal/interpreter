require_relative 'node'

module Ast
  module Expression
    include Node

    def expression_node
      raise NotImplementedError, "Subclasses must implement the 'expression_node' method"
    end
  end
end
