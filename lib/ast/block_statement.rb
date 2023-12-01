require_relative 'statement'

module Ast
  class BlockStatement
    include Statement

    attr_reader :token, :statements

    def initialize(token, statements)
      @token = token
      @statements = statements
    end

    def statement_node; end

    def token_literal
      @token.literal
    end

    def debug
      @statements.map(&:debug)
    end
  end
end
