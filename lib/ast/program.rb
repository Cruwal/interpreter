module Ast
  class Program
    attr_accessor :statements

    def initialize(statements = [])
      @statements = statements
    end

    def token_literal
      if statements.legth.positive?
        statements[0].token_literal
      else
        ''
      end
    end

    def debug
      statements.map(&:debug)
    end
  end
end
