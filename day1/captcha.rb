# frozen_string_literal: true

class NumbaCaptcha
  attr_reader :solution

  def initialize(numba)
    @numba = numba
    @numba_a = convert_to_digits(numba)
    @solution = []
    @current_number = nil
  end

  def perform
    pairs = matching_pairs
    @solution = pairs.reduce(:+)
    @numba
  end

  private

  # Ruby magic time. Build array pair of every two elements. So,
  #   [1, 2, 3, 4] => [1, 2], [2, 3], [3, 4].
  # From there, we map only the numbers that are equal out in the ternary
  #   and compact to kill all the nils.
  #
  # The tiny, tiny cavet that the array is circular, means we have
  #   to check if the firstis equal to the last, and go from there.
  #
  # @return [Array] array of numbers that are found in pairs in a string.
  def matching_pairs
    pairs = @numba_a.each_cons(2)
                    .map { |a| a.first == a.last ? a.first : nil }
                    .compact
    pairs << @numba_a.first if @numba_a.first == @numba_a.last
    pairs
  end

  def convert_to_digits(number)
    number.to_s.chars.to_a.map(&:to_i)
  end
end
