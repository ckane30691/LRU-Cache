class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    total = 0
    self.each_with_index do |el, idx|
      total += idx * el.to_s.ord
    end
    total.hash
  end
end

class String
  def hash
    total = 0
    self.split("").each_with_index { |chr, idx| total += chr.ord * idx }
    total.hash
  end

end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    str = ""
    self.each { |k, v| str.concat(k.to_s) + v.to_s }
    str.split("").sort.join("").hash
  end
end
