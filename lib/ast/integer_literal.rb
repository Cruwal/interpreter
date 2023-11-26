require_relative 'expression'

module Ast
  class IntegerLiteral
    include Expression

    attr_reader :token, :identifier, :expression

    def initialize(token, value)
      @token = token
      @value = value
    end

    def expression_node; end

    def token_literal
      @token.literal
    end
  end
end
