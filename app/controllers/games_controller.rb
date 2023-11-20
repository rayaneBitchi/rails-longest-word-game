require 'open-uri'
require 'json'

class GamesController < ApplicationController
    def new
        @grid = []
        i = 0
        until i == 9
            @grid << ('a'..'z').to_a.sample.upcase
            i += 1
        end
        @grid
    end

    def score
        @grid = params[:grid].gsub(" ", "")
        @attempt =  params[:word]
        @message = ''
        url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
        attempt_serialized = URI.open(url).read
        result = JSON.parse(attempt_serialized)
        validation = valid_attempt?(@attempt, @grid) && !over_used_letter?(@attempt)
        @message =  validation ? "Congratulation! #{@attempt.upcase} is a valid English word!" : "Sorry but #{@attempt.upcase} can't be bild out of #{@grid.chars.join(', ')}"
        @message = "Sorry but #{@attempt.upcase} does not seem to be a valid English word..." unless result["found"]

    end

    private

    def valid_attempt?(attempt, grid)
        is_valid = true
        attempt.chars.each do |w|
        return false unless grid.include?(w.upcase)
        end
        return is_valid
    end

    def over_used_letter?(attempt)
    i = 0
    over_used = false
    attempt_array = attempt.chars
    while i < attempt_array.length
        return true if attempt_array[i].eql?(attempt_array[i + 1])
        i += 1
    end
    return over_used
    end
end
