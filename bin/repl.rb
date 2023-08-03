require_relative '../lib/lexer'

begin
  loop do
    print '>> '
    input = $stdin.read

    lexer = Lexer.new(input)
    loop do
      token = lexer.next_token
      puts token

      break if token[:token] == 'EOF'
    end
  end
rescue Interrupt
  puts "\nStopping execution\n"
end
