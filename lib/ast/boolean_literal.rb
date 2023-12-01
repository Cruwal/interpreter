require_relative 'expression'

module Ast
  class BooleanLiteral
    include Expression

    attr_reader :token, :value

    def initialize(token, value)
      @token = token
      @value = value
    end

    def expression_node; end

    def token_literal
      @token.literal
    end

    def debug
      @token[:literal]
    end
  end
end
