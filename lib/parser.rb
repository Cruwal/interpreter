# frozen_string_literal: true

require 'ast/program'
require 'ast/let_statement'
require 'ast/identifier'
require 'ast/return_statement'
require 'ast/expression_statement'
require 'ast/integer_literal'
require 'ast/boolean_literal'
require 'ast/prefix_expression'
require 'ast/infix_expression'

class Parser
  attr_reader :program, :errors

  PRECEDENCE = {
    lowest: 1,
    equals: 2,
    lessgreater: 3,
    sum: 4,
    product: 5,
    prefix: 6,
    call: 7
  }.freeze

  PREFIX_FUNCTIONS = {
    IDENT: :parse_identifier,
    INT: :parse_integer_literal,
    BANG: :parse_prefix_expression,
    MINUS: :parse_prefix_expression,
    TRUE: :parse_boolean_literal,
    FALSE: :parse_boolean_literal,
    LPAREN: :parse_grouped_expression
  }.freeze

  INFIX_FUNCTIONS = {
    EQUAL: :parse_infix_expression,
    NOT_EQUAL: :parse_infix_expression,
    LT: :parse_infix_expression,
    GT: :parse_infix_expression,
    PLUS: :parse_infix_expression,
    MINUS: :parse_infix_expression,
    SLASH: :parse_infix_expression,
    ASTERISK: :parse_infix_expression
  }.freeze

  INFIX_PRECEDENCES = {
    EQUAL: PRECEDENCE[:equals],
    NOT_EQUAL: PRECEDENCE[:equals],
    LT: PRECEDENCE[:lessgreater],
    GT: PRECEDENCE[:lessgreater],
    PLUS: PRECEDENCE[:sum],
    MINUS: PRECEDENCE[:sum],
    SLASH: PRECEDENCE[:product],
    ASTERISK: PRECEDENCE[:product]
  }.freeze

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
    while @current_token[:token] != :EOF
      statement = parse_statement
      @program.statements << statement unless statement.nil?

      next_token
    end

    @program
  end

  private

  def parse_statement
    case @current_token[:token]
    when :LET
      parse_let_statement
    when :RETURN
      parse_return_statement
    else
      parse_expression_statement
    end
  end

  def parse_let_statement
    token = @current_token

    return nil unless expect_peek(:IDENT)

    ident_node = Ast::Identifier.new(@current_token, @current_token[:literal])

    return nil unless expect_peek(:ASSIGN)

    # expression_node = parse_expression

    next_token while @current_token[:token] != :SEMICOLON

    Ast::LetStatement.new(token, ident_node, nil)
  end

  def parse_return_statement
    token = @current_token

    # expression_node = parse_expression

    next_token while @current_token[:token] != :SEMICOLON

    Ast::ReturnStatement.new(token, nil)
  end

  def parse_expression_statement
    token = @current_token
    expression = parse_expression(PRECEDENCE[:lowest])

    next_token if @peek_token[:token] == :SEMICOLON

    Ast::ExpressionStatement.new(token, expression)
  end

  def parse_expression(precedence)
    prefix = PREFIX_FUNCTIONS[@current_token[:token]]
    return nil if prefix.nil?

    left_expression = send(prefix)

    while @peek_token[:token] != :SEMICOLON && precedence < peek_precedence
      infix = INFIX_FUNCTIONS[@peek_token[:token]]
      return left if infix.nil?

      next_token

      left_expression = send(infix, left_expression)
    end

    left_expression
  end

  def parse_identifier
    Ast::Identifier.new(@current_token, @current_token[:literal])
  end

  def parse_integer_literal
    Ast::IntegerLiteral.new(@current_token, @current_token[:literal].to_f)
  end

  def parse_boolean_literal
    Ast::BooleanLiteral.new(@current_token, @current_token[:literal] == 'true')
  end

  def parse_prefix_expression
    current_token = @current_token
    next_token

    Ast::PrefixExpression.new(current_token, current_token[:literal], parse_expression(PRECEDENCE[:prefix]))
  end

  def parse_grouped_expression
    next_token

    expression = parse_expression(PRECEDENCE[:lowest])

    return nil unless expect_peek(:RPAREN)

    expression
  end

  def parse_infix_expression(left_expression)
    current_token = @current_token

    precedence = current_precedence
    next_token

    Ast::InfixExpression.new(current_token, left_expression, current_token[:literal], parse_expression(precedence))
  end

  def current_precedence
    INFIX_PRECEDENCES[@current_token[:token].to_sym] || PRECEDENCE[:lowest]
  end

  def peek_precedence
    INFIX_PRECEDENCES[@peek_token[:token].to_sym] || PRECEDENCE[:lowest]
  end

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
