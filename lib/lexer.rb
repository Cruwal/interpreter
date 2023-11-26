TOKENS = {
  ILLEGAL: 'ILLEGAL',
  EOF: 'EOF',
  IDENT: 'IDENT',
  INT: 'INT',
  ASSIGN: '=',
  PLUS: '+',
  MINUS: '-',
  BANG: '!',
  ASTERISK: '*',
  SLASH: '/',
  LT: '<',
  GT: '>',
  EQUAL: '==',
  NOT_EQUAL: '!=',
  COMMA: ',',
  SEMICOLON: ';',
  LPAREN: '(',
  RPAREN: ')',
  LBRACE: '{',
  RBRACE: '}',
  FUNCTION: 'FUNCTION',
  LET: 'LET',
  IF: 'IF',
  ELSE: 'ELSE',
  RETURN: 'RETURN',
  FALSE: 'FALSE',
  TRUE: 'TRUE'
}.freeze

KEYWORDS = {
  'let' => :LET,
  'fn' => :FUNCTION,
  'true' => :TRUE,
  'false' => :FALSE,
  'return' => :RETURN,
  'if' => :IF,
  'else' => :ELSE
}.freeze

class Lexer
  def initialize(source_code = '')
    @source_code = source_code
    @position = 0
    @read_position = 1
    @character = @source_code[0]
  end

  def next_token
    skip_whitespace

    case @character
    when '='
      token = tokenize_equal_sign
    when '+'
      token = { token: :PLUS, literal: @character }
    when '-'
      token = { token: :MINUS, literal: @character }
    when '!'
      token = tokenize_bang_sign
    when '*'
      token = { token: :ASTERISK, literal: @character }
    when '/'
      token = { token: :SLASH, literal: @character }
    when '<'
      token = { token: :LT, literal: @character }
    when '>'
      token = { token: :GT, literal: @character }
    when ','
      token = { token: :COMMA, literal: @character }
    when ';'
      token = { token: :SEMICOLON, literal: @character }
    when '('
      token = { token: :LPAREN, literal: @character }
    when ')'
      token = { token: :RPAREN, literal: @character }
    when '{'
      token = { token: :LBRACE, literal: @character }
    when '}'
      token = { token: :RBRACE, literal: @character }
    when nil
      token = { token: :EOF, literal: @character }
    else
      return tokenize_identifier
    end

    read_char
    token
  end

  private

  def tokenize_equal_sign
    next_char = peak_char
    if next_char == '='
      token = { token: :EQUAL, literal: @character + next_char }
      read_char
    else
      token = { token: :ASSIGN, literal: @character }
    end

    token
  end

  def tokenize_bang_sign
    next_char = peak_char
    if next_char == '='
      token = { token: :NOT_EQUAL, literal: @character + next_char }
      read_char
    else
      token = { token: :BANG, literal: @character }
    end

    token
  end

  def tokenize_identifier
    if @character.match?(/[A-Za-z_]/)
      identifier = read_pattern(/[A-Za-z_]/)
      token_key = KEYWORDS[identifier] || :IDENT

      { token: token_key, literal: identifier }
    elsif @character.match?(/[0-9]/)
      number = read_pattern(/[0-9]/)

      { token: :INT, literal: number.to_i }
    end
  end

  def read_char
    if @read_position.nil? || @read_position >= @source_code.size
      @read_position = nil
      @character = nil
    else
      @character = @source_code[@read_position]
      @position = @read_position
      @read_position += 1
    end
  end

  def read_pattern(pattern)
    value = ''

    while @character.match?(pattern)
      value << @character

      read_char
    end

    value
  end

  def peak_char
    if @read_position.nil? || @read_position >= @source_code.size
      nil
    else
      @source_code[@read_position]
    end
  end

  def skip_whitespace
    read_char while [' ', "\r", "\t", "\n"].include?(@character)
  end
end
