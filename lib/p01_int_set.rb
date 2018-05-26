class MaxIntSet
  def initialize(max, num_buckets = 20)
    @max = max
    @store = Array.new(num_buckets) { false }
  end

  def insert(num)
    raise "Out of bounds" unless is_valid?(num)
    @store[num] = true
  end

  def remove(num)
    @store[num] = false
  end

  def include?(num)
    @store[num] == true ? true : false
  end

  private

  def is_valid?(num)
    validate!(num)
  end

  def validate!(num)
    num > @max || num < 0 ? false : true
  end
end


class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    self[num].push(num)
  end

  def remove(num)
    self[num] = self[num].select { |el| el != num }
  end

  def include?(num)
    return self[num].any? { |el| el == num }
  end

  private

  def []=(num, new_bucket)
    @store[num % num_buckets] = new_bucket
  end

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    if num_buckets > count
      unless include?(num)
        @count += 1
        self[num].push(num)
      end
    else
      resize!
      insert(num)
    end
  end

  def remove(num)
    result = []
    self[num].each do |el|
      if el == num
        @count -= 1
      else
        result.push(el)
      end
    end
    self[num] = result
  end

  def include?(num)
    return self[num].any? { |el| el == num }
  end

  private

  def []=(num, new_bucket)
    @store[num % num_buckets] = new_bucket
  end

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    oldStore = @store
    @store = (Array.new(num_buckets * 2) { Array.new })
    @count = 0
    oldStore.each do |bucket|
      bucket.each do |el|
        insert(el)
      end
    end
  end

end
