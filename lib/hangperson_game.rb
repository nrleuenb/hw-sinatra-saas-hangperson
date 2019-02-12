class HangpersonGame
    attr_accessor(:word, :guesses, :wrong_guesses)

    # add the necessary class methods, attributes, etc. here
    # to make the tests in spec/hangperson_game_spec.rb pass.

    # Get a word from remote "random word" service

    # def initialize()
    # end

    def initialize(word)
        @word = word
        @guesses = ''
        @wrong_guesses = ''
    end

    # You can test it by running $ bundle exec irb -I. -r app.rb
    # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
    #  => "cooking"   <-- some random word
    def self.get_random_word
        require 'uri'
        require 'net/http'
        uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
        Net::HTTP.new('watchout4snakes.com').start { |http|
            return http.post(uri, "").body
        }
    end

    def guess(letter)
        if letter.nil? or letter.empty? or /(\W|\d|_)/.match(letter)
            raise ArgumentError
        end

        if @guesses.downcase.include? letter.downcase or @wrong_guesses.downcase.include? letter.downcase
            return false
        end

        if @word.include? letter
            @guesses << letter
            return true
        else
            @wrong_guesses << letter
            return true
        end
    end

    def word_with_guesses
        display = ''
        @word.each_char { |i|
            if @guesses.include? i
                display << i
            else
                display << '-'
            end
        }
        display
    end

    def check_win_or_lose
        guessed = word_with_guesses()
        if @wrong_guesses.size === 7
            return :lose
        elsif guessed === @word
            return :win
        else
            return :play
        end
    end

end
