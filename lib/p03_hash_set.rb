require_relative 'p02_hashing'

# Similar to ResizingIntSet except this time we hash a key to an int
# before modding and putting it into our array bucket
class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    num = key.hash
    if num_buckets > count
      unless include?(key)
        @count += 1
        self[num].push(key)
      end
    else
      resize!
      insert(key)
    end
  end

  def include?(key)
    num = key.hash
    return self[num].any? { |el| el == key }
  end

  def remove(key)
    num = key.hash
    result = []
    self[num].each do |el|
      if el == key
        @count -= 1
      else
        result.push(el)
      end
    end
    self[num] = result
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
