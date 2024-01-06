require_relative 'expression'

module Ast
  class CallExpression
    include Expression

    attr_reader :token, :function, :arguments

    def initialize(token, function, arguments)
      @token = token
      @function = function
      @arguments = arguments
    end

    def expression_node; end

    def token_literal
      @token.literal
    end

    def debug
      "#{@function.debug}(#{@arguments.map(&:debug).join(', ')})"
    end
  end
end
