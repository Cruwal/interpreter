require_relative 'statement'

module Ast
  class ReturnStatement
    include Statement

    attr_reader :token, :expression

    def initialize(token, expression)
      @token = token
      @expression = expression
    end

    def statement_node; end

    def token_literal
      @token.literal
    end

    def debug
      "#{@token[:literal]} #{@expression&.debug};"
    end
  end
end
