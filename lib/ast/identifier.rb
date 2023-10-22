require_relative 'expression'

module Ast
  class Identifier
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
  end
end
