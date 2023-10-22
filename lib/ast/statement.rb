require_relative 'node'

module Ast
  module Statement
    include Node

    def statement_node
      raise NotImplementedError, "Subclasses must implement the 'statement_node' method"
    end
  end
end
