require_relative 'p02_hashing'
require_relative 'p04_linked_list'

class HashMap

  include Enumerable

  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    return self[key] ? true : false
  end

  def set(key, val)
    num = key.hash
    if num_buckets > count
      setBucket = bucket(key)
      unless setBucket.include?(key)
        @count += 1
        setBucket.append(key, val)
      else
        setBucket.update(key, val)
      end
    else
      resize!
      set(key, val)
    end
  end

  def get(key)
    bucket(key).get(key)
  end

  def delete(key)
    @count -= 1
    bucket(key).remove(key)
  end

  def each(&prc)
    @store.each do |bucket|
      bucket.each do |node|
        prc.call(node.key, node.val)
      end
    end
  end

  # uncomment when you have Enumerable included
  # def to_s
  #   pairs = inject([]) do |strs, (k, v)|
  #     strs << "#{k.to_s} => #{v.to_s}"
  #   end
  #   "{\n" + pairs.join(",\n") + "\n}"
  # end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    oldStore = @store
    @store = (Array.new(num_buckets * 2) { LinkedList.new })
    @count = 0
    oldStore.each do |bucket|
      bucket.each do |el|
        set(el.key, el.val)
      end
    end
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    num = key.hash
    @store[num % num_buckets]
  end
end
