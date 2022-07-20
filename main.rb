class CodeMaker
  attr_accessor :code

  CODE_CHOICES = [1, 2, 3, 4, 5, 6]

  def initialize
    @code = 0
  end

  def cpu_select_code
    self.code = CODE_CHOICES.sample(4).join
  end
end

class CodeBreaker
  def initialize
  end
end
