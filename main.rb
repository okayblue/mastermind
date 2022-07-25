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
    if guess == code
      p 'You figured out the secret code!'
    elsif guess != code
      puts 'Incorrect!'
      hint(guess)
    end
  end

  def hint(guess)
    hint = []
    exact = []
    other = []
    # hint legend: '*' = correct number in correct spot, '=' = correct number in incorrect spot
    guess.split('').each_with_index do |num, index|
      if code[index].eql?(num)
        hint.push('*')
        exact.push(num)
      else
        other.push(num)
      end
    end
    other.each_with_index do |num, index|
      if code.include?(num) && !exact.include?(num)
        hint.push('=')
      end
    end
    puts hint.join(' ')
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

codebreak = CodeBreaker.new
make = CodeMaker.new

make.cpu_select_code
p make.code
codebreak.code_guess
make.guess_check(codebreak.guess)