module Choices
  CODE_CHOICES = ['1', '2', '3', '4', '5', '6']
end

class CodeMaker
  include Choices
  attr_accessor :code

  def initialize
    @code = 0
  end

  def cpu_select_code
    self.code = CODE_CHOICES.sample(4).join
    puts 'The secret code has been chosen'
  end

  def guess_check(guess)
    win = false
    if guess == code
      p 'You figured out the secret code!'
      win = true
    elsif guess != code
      puts 'Incorrect!'
      hint(guess)
    end
    win
  end

  def hint(guess)
    hint = ['', '', '', '']
    # hint legend: '*' = correct number in correct spot, 'o' = correct number in incorrect spot
    guess.split('').each_with_index { |num, index| hint.unshift('*').pop if code[index].eql?(num) }
    guess.split('').uniq.each { |num| hint.unshift('o').pop if code.include?(num) &&  hint[-1] == '' }
    puts "Hints: #{hint.join(' ')}"
  end
end

class CodeBreaker
  include Choices
  attr_accessor :guess

  def initialize
    @guess = 0
  end

  def code_guess
    guess_input = ''
    until guess_input.length == 4 && guess_input.split('').all? { |i| CODE_CHOICES.include?(i) }
      puts 'Enter a guess - 4 numbers from 1-6'
      guess_input = gets.chomp
    end
    self.guess = guess_input
  end
end

class Game
  attr_reader :breaker, :maker
  attr_accessor :turns
  def initialize
    @breaker = CodeBreaker.new
    @maker = CodeMaker.new
    @turns = 12
  end

  def play_game
    puts "Welcome to mastermind!\n"
    maker.cpu_select_code
    puts maker.code
    until turns.zero?
      breaker.code_guess
      break if maker.guess_check(breaker.guess)
      self.turns -= 1
      puts "turns left: #{turns}"
      puts "The CodeMaker wins! The secret code was #{maker.code}" if turns.zero?
    end
  end

  def play_again
    puts 'Play again? (Y/N)'
    newgame = ''
    until newgame.downcase == 'y' or newgame.downcase == 'n'
      newgame = gets.chomp
    end
    newgame
  end
end

loop do
  game = Game.new
  game.play_game
  next if game.play_again == 'y'
  break
end
