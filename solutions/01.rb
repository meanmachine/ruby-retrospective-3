class Integer
  def prime?
    return false if pred < 1
    2.upto(pred).all? { |integer| remainder(integer).nonzero? }
  end

  def prime_factors
    2.upto(abs).each do |number|
      if abs.remainder(number).zero? and number.prime?
        return [number] + (abs / number).prime_factors
      end
    end
    []
  end

  def harmonic
    downto(1).map { |number| Rational(1, number) }.reduce(:+)
  end

  def digits
    return [abs] if abs < 10
    (abs / 10).digits + [abs % 10]
  end
end

class Array
  def frequencies
    Hash[each.map { |element| [element, count(element)] }]
  end

  def average
    reduce(:+) / size.to_f
  end

  def drop_every(n)
    each_index.reject { |index| index.next.remainder(n).zero? }.map do |index|
      at(index)
    end
  end

  def combine_with(other)
    shorter_size    = size < other.size ? size : other.size
    combined_array  = [self[0...shorter_size], other[0...shorter_size]]
    combined_array  = combined_array.transpose
    combined_array += self[shorter_size..-1]
    combined_array += other[shorter_size..-1]
    combined_array.flatten
  end
end