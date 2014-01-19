class Array
  def find_each
    each do | item |
      yield item
    end
  end
end
