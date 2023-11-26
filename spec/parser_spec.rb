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
    parser.parse_program

    statements = parser.program.statements

    expect(statements.first.token).to eql({ token: 'LET', literal: 'let' })
    expect(statements.first.identifier.token).to eql({ token: 'IDENT', literal: 'five' })
    expect(statements.first.identifier.value).to eql('five')
    expect(statements.first.expression).to be_nil

    expect(statements.last.token).to eql({ token: 'LET', literal: 'let' })
    expect(statements.last.identifier.token).to eql({ token: 'IDENT', literal: 'ten' })
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

      statements = parser.program.statements
      errors = parser.errors

      # expect(statements).to be_empty
      expect(errors.first).to eql('expected next token to be =, got INT instead')
      expect(errors.last).to eql('expected next token to be IDENT, got = instead')
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
      parser.parse_program

      statements = parser.program.statements

      expect(statements.first.token).to eql({ token: 'RETURN', literal: 'return' })
      expect(statements.first.expression).to be_nil

      expect(statements.last.token).to eql({ token: 'RETURN', literal: 'return' })
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
      parser.parse_program

      statements = parser.program.statements

      expect(statements.first.token).to eql({ token: 'IDENT', literal: 'identifier' })
    end
  end

  context 'when parser a valid integer' do
    let(:input) do
      <<-TEXT
        5;
      TEXT
    end

    it 'expects the return statement to parsed correctly' do
      parser.parse_program

      statements = parser.program.statements

      expect(statements.first.token).to eql({ token: 'INT', literal: 5 })
    end
  end

  context 'when parser a valid expression' do
    let(:input) do
      <<-TEXT
        -a * b;
      TEXT
    end

    it 'expects the return statement to parsed correctly' do
      parser.parse_program

      statements = parser.program.statements
      expect(statements.first.token).to eql({ token: '-', literal: '-' })
      expect(statements[1].token).to eql({ token: 'IDENT', literal: 'a' })
      expect(statements[2].token).to eql({ token: '*', literal: '*' })
      expect(statements.last.token).to eql({ token: 'IDENT', literal: 'b' })
    end
  end
end
