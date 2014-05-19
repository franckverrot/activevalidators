module LuhnChecker
  # This method implements Luhn algorythm.
  # Details about it's work may be founded here: http://en.wikipedia.org/wiki/Luhn_Algorithm
  def self.valid?(s)
    value = s.gsub(/\D/, '').reverse

    sum = i = 0

    value.each_char do |ch|
      n = ch.to_i

      n *= 2 if i.odd?

      n = 1 + (n - 10) if n >= 10

      sum += n
      i   += 1
    end

    (sum % 10).zero?
  end
end