require_relative 'statement'

module Ast
  class LetStatement
    include Statement

    attr_reader :token, :identifier, :expression

    def initialize(token, identifier, expression)
      @token = token
      @identifier = identifier
      @expression = expression
    end

    def statement_node; end

    def token_literal
      @token.literal
    end
  end
end
