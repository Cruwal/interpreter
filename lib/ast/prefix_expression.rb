require_relative 'expression'

module Ast
  class PrefixExpression
    include Expression

    attr_reader :token, :operator, :right

    def initialize(token, operator, right)
      @token = token
      @operator = operator
      @right = right
    end

    def statement_node; end

    def token_literal
      @token.literal
    end

    def debug
      "(#{@operator}#{@right&.debug})"
    end
  end
end
