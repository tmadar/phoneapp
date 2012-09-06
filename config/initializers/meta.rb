class Object
  def rsend(*args, &block)
    obj = self
    args.each do |a|
      b = (a.is_a?(Array) && a.last.is_a?(Proc) ? a.pop : block)
      obj = obj.__send__(*a, &b)
    end
    obj
  end
  alias_method :__rsend__, :rsend
end