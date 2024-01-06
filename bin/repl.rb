$LOAD_PATH.unshift(File.expand_path('.', 'lib'))

require 'lexer'
require 'parser'

begin
  loop do
    print '>> '
    input = $stdin.read

    lexer = Lexer.new(input)
    program = Parser.new(lexer).parse_program

    puts program.debug
  end
rescue Interrupt
  puts "\nStopping execution\n"
end
