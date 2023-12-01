require_relative 'expression'

module Ast
  class IfExpression
    include Expression

    attr_reader :token, :condition, :consequece, :alternative

    def initialize(token, condition, consequence, alternative)
      @token = token
      @condition = condition
      @consequence = consequence
      @alternative = alternative
    end

    def statement_node; end

    def token_literal
      @token.literal
    end

    def debug
      response = "if#{@condition.debug} #{@consequence.debug}"

      return response if @alternative.nil?

      response + " else #{@alternative.debug}"
    end
  end
end
