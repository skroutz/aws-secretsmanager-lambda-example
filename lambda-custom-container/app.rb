module Lambdas
  class App
    def self.process(event:, context:)
      puts "The secret value is: #{ENV['SECRET_VALUE_1']}"
      puts "The secret value is: #{ENV['SECRET_VALUE_2']}"
    end
  end
end
