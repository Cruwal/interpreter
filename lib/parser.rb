# frozen_string_literal: true

require 'ast/program'
require 'ast/let_statement'
require 'ast/identifier'
require 'ast/return_statement'

class Parser
  attr_reader :program, :errors

  def initialize(lexer)
    @lexer = lexer
    @current_token = nil
    @peek_token = nil
    @program = Ast::Program.new
    @errors = []

    next_token
    next_token
  end

  def parse_program
    while @current_token[:token] != 'EOF'
      statement = parse_statement
      @program.statements << statement unless statement.nil?

      next_token
    end

    @statements
  end

  private

  def parse_statement
    case @current_token[:token]
    when 'LET'
      parse_let_statement
    when 'RETURN'
      parse_return_statement
    end
  end

  def parse_let_statement
    token = @current_token

    return nil unless expect_peek('IDENT')

    ident_node = Ast::Identifier.new(@current_token, @current_token[:literal])

    return nil unless expect_peek('=')

    # expression_node = parse_expression

    next_token while @current_token[:token] != ';'

    Ast::LetStatement.new(token, ident_node, nil)
  end

  def parse_return_statement
    token = @current_token

    # expression_node = parse_expression

    next_token while @current_token[:token] != ';'

    Ast::ReturnStatement.new(token, nil)
  end

  def parse_expression; end

  def peek_error(type)
    @errors << "expected next token to be #{type}, got #{@peek_token[:token]} instead"
  end

  def expect_peek(token)
    if @peek_token[:token] != token
      peek_error(token)

      return false
    end

    next_token

    true
  end

  def next_token
    @current_token = @peek_token
    @peek_token = @lexer.next_token
  end
end
