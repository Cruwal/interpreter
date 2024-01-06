# frozen_string_literal: true

require 'lexer'
require 'parser'
require 'pry'

RSpec.describe Parser do
  let(:parser) { described_class.new(tokens) }
  let(:input) do
    <<-TEXT
      let five = 5;
      let ten = 10;
    TEXT
  end
  let(:tokens) { Lexer.new(input) }

  it 'expects the let statement to be parsed correctly' do
    program = parser.parse_program
    statements = program.statements

    expect(statements.first.token).to eql({ token: :LET, literal: 'let' })
    expect(statements.first.identifier.token).to eql({ token: :IDENT, literal: 'five' })
    expect(statements.first.identifier.value).to eql('five')
    expect(statements.first.expression).to be_nil

    expect(statements.last.token).to eql({ token: :LET, literal: 'let' })
    expect(statements.last.identifier.token).to eql({ token: :IDENT, literal: 'ten' })
    expect(statements.last.identifier.value).to eql('ten')
    expect(statements.first.expression).to be_nil
  end

  context 'when provides an invalid let statement' do
    let(:input) do
      <<-TEXT
        let five  5;
        let = 10;
      TEXT
    end

    it 'expects the correct error messages' do
      parser.parse_program
      errors = parser.errors

      # expect(statements).to be_empty
      expect(errors.first).to eql('expected next token to be ASSIGN, got INT instead')
      expect(errors.last).to eql('expected next token to be IDENT, got ASSIGN instead')
    end
  end

  context 'when parser a valid return statement' do
    let(:input) do
      <<-TEXT
        return 5;
        return 10;
      TEXT
    end

    it 'expects the return statement to parsed correctly' do
      program = parser.parse_program
      statements = program.statements

      expect(statements.first.token).to eql({ token: :RETURN, literal: 'return' })
      expect(statements.first.expression).to be_nil

      expect(statements.last.token).to eql({ token: :RETURN, literal: 'return' })
      expect(statements.first.expression).to be_nil
    end
  end

  context 'when parser a valid identifier' do
    let(:input) do
      <<-TEXT
        identifier;
      TEXT
    end

    it 'expects the return statement to parsed correctly' do
      program = parser.parse_program
      statements = program.statements

      expect(statements.first.token).to eql({ token: :IDENT, literal: 'identifier' })
    end
  end

  context 'when parser a valid integer' do
    let(:input) do
      <<-TEXT
        5;
      TEXT
    end

    it 'expects the return statement to parsed correctly' do
      program = parser.parse_program
      statements = program.statements

      expect(statements.first.token).to eql({ token: :INT, literal: 5 })
    end
  end

  context 'when parser a valid expression' do
    let(:input) do
      <<-TEXT
        -a * b;
      TEXT
    end

    it 'expects the return statement to parsed correctly' do
      program = parser.parse_program
      statements = program.statements
      expression = statements.first.expression

      expect(program.debug).to eql(['((-a) * b);'])
      expect(expression.left.token).to eql({ token: :MINUS, literal: '-' })
      expect(expression.left.right.token).to eql({ token: :IDENT, literal: 'a' })
      expect(expression.operator).to eql('*')
      expect(expression.right.token).to eql({ token: :IDENT, literal: 'b' })
    end
  end

  context 'when parser a valid boolean' do
    let(:input) do
      <<-TEXT
         false != true;
      TEXT
    end

    it 'expects the return statement to parsed correctly' do
      program = parser.parse_program
      statements = program.statements
      expression = statements.first.expression

      expect(program.debug).to eql(['(false != true);'])
      expect(expression.left.token).to eql({ token: :FALSE, literal: 'false' })
      expect(expression.right.token).to eql({ token: :TRUE, literal: 'true' })
      expect(expression.operator).to eql('!=')
    end
  end

  context 'when parser a valid grouped expression' do
    let(:input) do
      <<-TEXT
         1 + (2 + 3) + 4;
      TEXT
    end

    it 'expects the return statement to parsed correctly' do
      program = parser.parse_program

      expect(program.debug).to eql(['((1 + (2 + 3)) + 4);'])
    end
  end

  # TODO: fix the block_statement debug method
  context 'when parser a valid if expression' do
    let(:input) do
      <<-TEXT
        if (x < y) { x } else { y }
      TEXT
    end

    it 'expects the return statement to parsed correctly' do
      program = parser.parse_program

      expect(program.debug).to eql(['if(x < y) ["x;"] else ["y;"];'])
    end
  end

  # TODO: fix the block_statement debug method
  context 'when parser a valid function literal' do
    let(:input) do
      <<-TEXT
        fn(x, y) { x + y }
      TEXT
    end

    it 'expects the return statement to parsed correctly' do
      program = parser.parse_program

      expect(program.debug).to eql(['fn(x, y) {(x + y);};'])
    end
  end

  context 'when parser a valid call expression' do
    let(:input) do
      <<-TEXT
        add(1, 2 * 3, 4 + 5)
      TEXT
    end

    it 'expects the return statement to parsed correctly' do
      program = parser.parse_program

      expect(program.debug).to eql(['add(1, (2 * 3), (4 + 5));'])
    end
  end
end
