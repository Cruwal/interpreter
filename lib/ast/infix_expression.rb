require_relative 'expression'

module Ast
  class InfixExpression
    include Expression

    attr_reader :token, :left, :operator, :right

    def initialize(token, left, operator, right)
      @token = token
      @left = left
      @operator = operator
      @right = right
    end

    def statement_node; end

    def token_literal
      @token.literal
    end

    def debug
      "(#{@left&.debug} #{@operator} #{@right&.debug})"
    end
  end
end
