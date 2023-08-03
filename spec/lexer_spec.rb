# frozen_string_literal: true

require 'lexer'

RSpec.describe Lexer do
  let(:lexer) { described_class.new(input) }
  let(:input) { '=+-!*<>(){},;' }

  it 'should return the correct tokens' do
    expect(lexer.next_token).to eql(token: '=', literal: '=')
    expect(lexer.next_token).to eql(token: '+', literal: '+')
    expect(lexer.next_token).to eql(token: '-', literal: '-')
    expect(lexer.next_token).to eql(token: '!', literal: '!')
    expect(lexer.next_token).to eql(token: '*', literal: '*')
    expect(lexer.next_token).to eql(token: '<', literal: '<')
    expect(lexer.next_token).to eql(token: '>', literal: '>')
    expect(lexer.next_token).to eql(token: '(', literal: '(')
    expect(lexer.next_token).to eql(token: ')', literal: ')')
    expect(lexer.next_token).to eql(token: '{', literal: '{')
    expect(lexer.next_token).to eql(token: '}', literal: '}')
    expect(lexer.next_token).to eql(token: ',', literal: ',')
    expect(lexer.next_token).to eql(token: ';', literal: ';')
    expect(lexer.next_token).to eql(token: 'EOF', literal: nil)
  end

  context 'when input has identifier' do
    let(:input) { 'let five = 5;' }

    it 'should return the the correct tokens' do
      expect(lexer.next_token).to eql(token: 'LET', literal: 'let')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'five')
      expect(lexer.next_token).to eql(token: '=', literal: '=')
      expect(lexer.next_token).to eql(token: 'INT', literal: 5)
    end
  end

  context 'when input has number' do
    let(:input) { 'let five = 512321;' }

    it 'should return the the correct tokens' do
      expect(lexer.next_token).to eql(token: 'LET', literal: 'let')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'five')
      expect(lexer.next_token).to eql(token: '=', literal: '=')
      expect(lexer.next_token).to eql(token: 'INT', literal: 512_321)
    end
  end

  context 'when input has a lot of spaces' do
    let(:input) { 'let           five       =         512321       ;         ' }

    it 'should return the the correct tokens' do
      expect(lexer.next_token).to eql(token: 'LET', literal: 'let')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'five')
      expect(lexer.next_token).to eql(token: '=', literal: '=')
      expect(lexer.next_token).to eql(token: 'INT', literal: 512_321)
    end
  end

  context 'when input does not have spaces' do
    let(:input) { 'let five=512321;' }

    it 'should return the the correct tokens' do
      expect(lexer.next_token).to eql(token: 'LET', literal: 'let')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'five')
      expect(lexer.next_token).to eql(token: '=', literal: '=')
      expect(lexer.next_token).to eql(token: 'INT', literal: 512_321)
    end
  end

  context 'when input has identifier' do
    let(:input) do
      <<-TEXT
      let five = 5;
      let ten = 10;
      let add = fn(x, y) {
        x + y;
      };
      let result = add(five, ten);
      TEXT
    end

    it 'should return the the correct tokens' do
      expect(lexer.next_token).to eql(token: 'LET', literal: 'let')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'five')
      expect(lexer.next_token).to eql(token: '=', literal: '=')
      expect(lexer.next_token).to eql(token: 'INT', literal: 5)
      expect(lexer.next_token).to eql(token: ';', literal: ';')
      expect(lexer.next_token).to eql(token: 'LET', literal: 'let')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'ten')
      expect(lexer.next_token).to eql(token: '=', literal: '=')
      expect(lexer.next_token).to eql(token: 'INT', literal: 10)
      expect(lexer.next_token).to eql(token: ';', literal: ';')
      expect(lexer.next_token).to eql(token: 'LET', literal: 'let')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'add')
      expect(lexer.next_token).to eql(token: '=', literal: '=')
      expect(lexer.next_token).to eql(token: 'FUNCTION', literal: 'fn')
      expect(lexer.next_token).to eql(token: '(', literal: '(')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'x')
      expect(lexer.next_token).to eql(token: ',', literal: ',')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'y')
      expect(lexer.next_token).to eql(token: ')', literal: ')')
      expect(lexer.next_token).to eql(token: '{', literal: '{')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'x')
      expect(lexer.next_token).to eql(token: '+', literal: '+')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'y')
      expect(lexer.next_token).to eql(token: ';', literal: ';')
      expect(lexer.next_token).to eql(token: '}', literal: '}')
      expect(lexer.next_token).to eql(token: ';', literal: ';')
      expect(lexer.next_token).to eql(token: 'LET', literal: 'let')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'result')
      expect(lexer.next_token).to eql(token: '=', literal: '=')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'add')
      expect(lexer.next_token).to eql(token: '(', literal: '(')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'five')
      expect(lexer.next_token).to eql(token: ',', literal: ',')
      expect(lexer.next_token).to eql(token: 'IDENT', literal: 'ten')
      expect(lexer.next_token).to eql(token: ')', literal: ')')
      expect(lexer.next_token).to eql(token: ';', literal: ';')
      expect(lexer.next_token).to eql(token: 'EOF', literal: nil)
    end
  end

  context 'when input has keywords' do
    let(:input) do
      <<-TEXT
      if true
        return 5
      else
        return false
      TEXT
    end

    it 'should return the the correct tokens' do
      expect(lexer.next_token).to eql(token: 'IF', literal: 'if')
      expect(lexer.next_token).to eql(token: 'TRUE', literal: 'true')
      expect(lexer.next_token).to eql(token: 'RETURN', literal: 'return')
      expect(lexer.next_token).to eql(token: 'INT', literal: 5)
      expect(lexer.next_token).to eql(token: 'ELSE', literal: 'else')
      expect(lexer.next_token).to eql(token: 'RETURN', literal: 'return')
    end
  end

  context 'when input has two characters operator' do
    let(:input) do
      <<-TEXT
      if true != false
        return 5
      else true == true
        return false
      TEXT
    end

    it 'should return the the correct tokens' do
      expect(lexer.next_token).to eql(token: 'IF', literal: 'if')
      expect(lexer.next_token).to eql(token: 'TRUE', literal: 'true')
      expect(lexer.next_token).to eql(token: '!=', literal: '!=')
      expect(lexer.next_token).to eql(token: 'FALSE', literal: 'false')
      expect(lexer.next_token).to eql(token: 'RETURN', literal: 'return')
      expect(lexer.next_token).to eql(token: 'INT', literal: 5)
      expect(lexer.next_token).to eql(token: 'ELSE', literal: 'else')
      expect(lexer.next_token).to eql(token: 'TRUE', literal: 'true')
      expect(lexer.next_token).to eql(token: '==', literal: '==')
      expect(lexer.next_token).to eql(token: 'TRUE', literal: 'true')
      expect(lexer.next_token).to eql(token: 'RETURN', literal: 'return')
      expect(lexer.next_token).to eql(token: 'FALSE', literal: 'false')
    end
  end
end
