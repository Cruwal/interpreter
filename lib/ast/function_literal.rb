require_relative 'expression'

module Ast
  class FunctionLiteral
    include Expression

    attr_reader :token, :paramenters, :body

    def initialize(token, parameters, body)
      @token = token
      @parameters = parameters
      @body = body
    end

    def expression_node; end

    def token_literal
      @token.literal
    end

    def debug
      response = "#{@token[:literal]}("
      response += @parameters.map(&:debug).join(', ')
      response += ') {'
      response += @body.debug.first
      response += '}'

      response
    end
  end
end
