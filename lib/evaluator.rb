class Evaluator
  class ReturnError < StandardError
    attr_reader :expression

    def initialize(expression)
      @expression = expression

      super
    end
  end

  def initialize(ast)
    @ast = ast
  end

  def eval_ast(node = @ast)
    case node
    when Ast::Program
      eval_program(node.statements)
    when Ast::ExpressionStatement
      eval_ast(node.expression)
    when Ast::IntegerLiteral
      node.value
    when Ast::BooleanLiteral
      node.value
    when Ast::PrefixExpression
      right_node = eval_ast(node.right)
      eval_prefix_expression(node.operator, right_node)
    when Ast::InfixExpression
      right_node = eval_ast(node.right)
      left_node = eval_ast(node.left)

      eval_infix_expression(node.operator, left_node, right_node)
    when Ast::BlockStatement
      eval_block_statement(node.statements)
    when Ast::IfExpression
      eval_if_expression(node)
    when Ast::ReturnStatement
      value = eval_ast(node.expression)

      raise ReturnError, value
    end
  end

  private

  def eval_program(statements)
    response = nil

    statements.each do |statement|
      response = eval_ast(statement)
    rescue ReturnError => e
      response = e.expression

      break
    end

    response
  end

  def eval_block_statement(statements)
    response = nil

    statements.each do |statement|
      response = eval_ast(statement)
    rescue ReturnError => e
      raise e
    end

    response
  end

  def eval_prefix_expression(operator, node)
    case operator
    when '!'
      eval_bang_operator_expression(node)
    when '-'
      eval_minus_prefix_operator_expression(node)
    end
  end

  def eval_bang_operator_expression(node)
    return true if node == false || node.nil?

    false
  end

  def eval_minus_prefix_operator_expression(node)
    return nil unless node.is_a?(Float)

    -1 * node
  end

  def eval_infix_expression(operator, left_node, right_node)
    number_expression = left_node.is_a?(Float) && right_node.is_a?(Float)

    return eval_number_infix_expression(operator, left_node, right_node) if number_expression

    case operator
    when '=='
      left_node == right_node
    when '!='
      left_node != right_node
    end
  end

  def eval_number_infix_expression(operator, left_node, right_node)
    left_node.send(operator, right_node)
  end

  def eval_if_expression(node)
    condition = eval_ast(node.condition)

    evaluated_condition = condition ? true : false

    if evaluated_condition
      eval_ast(node.consequence)
    elsif !node.alternative.nil?
      eval_ast(node.alternative)
    end
  end
end
