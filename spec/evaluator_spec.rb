# frozen_string_literal: true

require 'lexer'
require 'parser'
require 'evaluator'
require 'pry'

RSpec.describe Evaluator do
  let(:evaluator) { described_class.new(ast) }
  let(:input) do
    <<-TEXT
      5;
    TEXT
  end
  let(:tokens) { Lexer.new(input) }
  let(:ast) { Parser.new(tokens).parse_program }

  it 'evaluates the expression correctly' do
    expect(evaluator.eval_ast).to eql(5.0)
  end

  context 'when evaluate a boolean' do
    let(:input) do
      <<-TEXT
        true;
      TEXT
    end

    it 'evaluates the boolean correctly' do
      expect(evaluator.eval_ast).to eql(true)
    end
  end

  context 'when evaluate a bang operator' do
    let(:input) do
      <<-TEXT
        !true;
      TEXT
    end

    it 'evaluates the operator correctly' do
      expect(evaluator.eval_ast).to eql(false)
    end
  end

  context 'when evaluate a minus operator' do
    let(:input) do
      <<-TEXT
        -5;
      TEXT
    end

    it 'evaluates the operator correctly' do
      expect(evaluator.eval_ast).to eql(-5.0)
    end
  end

  context 'when evaluate a infix expression' do
    let(:input) do
      <<-TEXT
        5 + 2;
      TEXT
    end

    it 'evaluates the expression correctly' do
      expect(evaluator.eval_ast).to eql(7.0)
    end
  end

  context 'when evaluate an if/else expression' do
    let(:input) do
      <<-TEXT
        if (1 < 2) { 10 } else { 20 }
      TEXT
    end

    it 'evaluates the expression correctly' do
      expect(evaluator.eval_ast).to eql(10.0)
    end
  end
end
