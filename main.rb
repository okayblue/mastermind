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

  def player_select_code
    self.code = gets.chomp
  end

  def guess_check(guess)
    win = false
    if guess == code
      p 'You figured out the secret code!'
      win = true
    elsif guess != code
      puts 'Incorrect!'
    end
    win
  end

  def cpu_guess_check
    #
  end

  def hint(guess)
    correct_num = ['', '', '', '']
    hint = ['', '', '', '']
    # # hint legend: '*' = correct number in correct spot, 'o' = correct number in incorrect spot
    guess.split('').each_with_index do |num, index|
      if code[index].eql?(num)
        hint.unshift('*').pop
        correct_num.unshift(num).pop
      end
    end
    guess.split('').uniq.each_with_index do |num, index| 
      hint.unshift('o').pop if !correct_num.slice(0..index - 1).include?(num) && code.include?(num)
    end
    puts "Hint: #{hint.join}"
  end
end

class CodeBreaker
  include Choices
  attr_accessor :guess, :possible_choices

  def initialize
    @guess = 0
    @possible_choices = []
  end

  def get_choices
    CODE_CHOICES.repeated_permutation(4) { |p| possible_choices.push(p) }
  end

  def code_guess
    guess_input = ''
    until guess_input.length == 4 && guess_input.split('').all? { |i| CODE_CHOICES.include?(i) }
      puts 'Enter a guess - 4 numbers from 1-6'
      guess_input = gets.chomp
    end
    self.guess = guess_input
  end

  def cpu_code_guess
    self.guess = possible_choices.sample
    p "Cpu guess: #{guess.join('')}"
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

  def code_breaker_game
    maker.cpu_select_code
    puts maker.code
    until turns.zero?
      breaker.code_guess
      break if maker.guess_check(breaker.guess)
      maker.hint(breaker.guess)
      self.turns -= 1
      puts "turns left: #{turns}"
      puts "The CodeMaker wins! The secret code was #{maker.code}" if turns.zero?
    end
    play_again
  end

  def code_maker_game
    breaker.get_choices
    puts "Select a secret code (4 numbers, each can be numbers 1-6"
    maker.player_select_code
    until turns.zero?
      breaker.cpu_code_guess
      maker.cpu_guess_check
      self.turns -= 1
    end
    play_again
  end

  def play_game
    puts "Welcome to mastermind!\n"
    selection = ''
    until selection == '1' || selection == '2'
      puts "Want to be the code breaker[1] or code maker[2]?"
      selection = gets.chomp
    end

    if selection == '1'
      code_breaker_game
    elsif selection == '2'
      code_maker_game
    end

  end

  def play_again
    puts 'Play again? (Y/N)'
    newgame = ''
    until newgame.downcase == 'y' or newgame.downcase == 'n'
      newgame = gets.chomp
    end
    if newgame == 'y'
      game = Game.new
      game.play_game
    end
  end
end

game = Game.new
game.play_game
