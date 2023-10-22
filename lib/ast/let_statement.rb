require_relative 'statement'

module Ast
  class LetStatement
    include Statement

    attr_reader :token, :identifier, :expression

    def initialize(token, identifier, experession)
      @token = token
      @identifier = identifier
      @experession = experession
    end

    def statement_node; end

    def token_literal
      @token.literal
    end
  end
end
